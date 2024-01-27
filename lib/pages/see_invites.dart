import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/loading/ListRefreshable.dart';
import 'package:thdapp/providers/user_info_provider.dart';
import 'team_api.dart';
import '/models/team.dart';
import 'view_team.dart';

class AcceptButtonRow extends StatelessWidget {
  final void Function() acceptOnPressed;
  final void Function() declineOnPressed;

  const AcceptButtonRow(
      {required this.acceptOnPressed, required this.declineOnPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(
          width: 20,
        ),
        SolidButton(
          text: "Accept",
          onPressed: acceptOnPressed,
        ),
        const SizedBox(
          width: 20,
        ),
        SolidButton(
          text: "Decline",
          onPressed: declineOnPressed,
        )
      ],
    );
  }
}

class NoAcceptButtonRow extends StatelessWidget {
  final Function cancelOnPressed;

  const NoAcceptButtonRow({required this.cancelOnPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SolidButton(
          text: "Cancel",
          onPressed: cancelOnPressed,
        )
      ],
    );
  }
}

class RequestCard extends StatelessWidget {
  final dynamic request;
  final Function(dynamic) removeRequest;

  const RequestCard(this.request, this.removeRequest);

  bool checkAdmin(BuildContext context) {
    bool hasTeam = Provider.of<UserInfoModel>(context, listen: false).hasTeam;
    if (!hasTeam) return false;
    Team team = Provider.of<UserInfoModel>(context, listen: false).team;
    List<String> adminIds = team.admins.map((mem) => mem.id).toList();
    String id = Provider.of<UserInfoModel>(context, listen: false).id;
    return adminIds.contains(id);
  }

  @override
  Widget build(BuildContext context) {
    String requestType = request['type'];
    bool hasTeam = Provider.of<UserInfoModel>(context, listen: false).hasTeam;
    bool canAccept = (!hasTeam && requestType == "INVITE") ||
        (hasTeam && requestType == "JOIN" && checkAdmin(context));

    String inviteInfo =
        hasTeam ? request['user']['email'] : request['team']['name'];
    String requestID = request['_id'];
    String token = Provider.of<UserInfoModel>(context, listen: false).token;

    return Card(
        margin: const EdgeInsets.all(12),
        color: Theme.of(context).colorScheme.background,
        child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(requestType,
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 10),
                Text(inviteInfo, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                canAccept
                    ? AcceptButtonRow(acceptOnPressed: () async {
                        bool success = await acceptRequest(token, requestID);
                        if (!success) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Error accepting invite. "
                                "Please request for the invite to be resent."),
                          ));
                          removeRequest(request);
                        }
                        await Provider.of<UserInfoModel>(context, listen: false)
                            .fetchUserInfo();
                        if (requestType == 'INVITE') {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => ViewTeam(),
                                  settings: const RouteSettings(
                                    arguments: "",
                                  )),
                              (route) => route.isFirst);
                        }
                        removeRequest(request);
                      }, declineOnPressed: () async {
                        await declineRequest(token, requestID);
                        removeRequest(request);
                      })
                    : NoAcceptButtonRow(cancelOnPressed: () async {
                        await cancelRequest(token, requestID);
                        removeRequest(request);
                      })
              ],
            )));
  }
}

class ViewInvites extends StatefulWidget {
  @override
  _ViewInvitesState createState() => _ViewInvitesState();
}

class _ViewInvitesState extends State<ViewInvites> {
  List<dynamic> requestsList;
  Status fetchStatus = Status.notLoaded;

  Future<void> fetchData() async {
    String token = Provider.of<UserInfoModel>(context, listen: false).token;
    bool hasTeam = Provider.of<UserInfoModel>(context, listen: false).hasTeam;
    List<dynamic> fetchedList;
    if (hasTeam) {
      fetchedList = await getTeamMail(token);
    } else {
      fetchedList = await getUserMail(token);
    }
    setState(() {
      fetchStatus = fetchedList == null ? Status.error : Status.loaded;
      requestsList = fetchedList;
    });
  }

  void removeRequest(dynamic request) {
    setState(() {
      requestsList.remove(request);
    });
  }

  @override
  initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;
    return DefaultPage(
        backflag: true,
        reverse: true,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: RefreshIndicator(
              onRefresh: fetchData,
              child: GradBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.75,
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("INVITES",
                                      style:
                                          Theme.of(context).textTheme.displayLarge)
                                ])),
                        if (fetchStatus == Status.loaded &&
                            requestsList.isNotEmpty)
                          Expanded(
                            child: ListView.builder(
                              itemCount: requestsList.length,
                              itemBuilder: (context, index) {
                                return RequestCard(
                                    requestsList[index], removeRequest);
                              },
                            ),
                          )
                        else if (fetchStatus == Status.loaded &&
                            requestsList.isEmpty)
                          ListRefreshable(
                              child: Text(
                            "No invites",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ))
                        else if (fetchStatus == Status.error)
                          ListRefreshable(
                              child: Text(
                            "Error loading invites",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ))
                        else
                          const Center(child: CircularProgressIndicator())
                      ])),
            )));
  }
}
