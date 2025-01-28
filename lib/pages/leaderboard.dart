import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/loading/LoadingOverlay.dart';
import 'package:thdapp/models/lb_entry.dart';
import '../models/profile.dart';
import 'package:thdapp/api.dart';

class Leaderboard extends StatefulWidget {
  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<LBEntry> lbData = [];
  int selfRank = 0;
  String displayName = "";
  int totalPoints = 0;
  String token = "";
  bool loading = true;
  final TextEditingController _editNicknameController = TextEditingController();

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    String id = prefs.getString('id') ?? "";

    lbData = await getLeaderboard();
    selfRank = await getSelfRank(token);
    Profile userData = await getProfile(id, token);
    totalPoints = userData.totalPoints;
    displayName = userData.displayName;
    loading = false;
    setState(() {});
  }

  _editNickname() async {
    _editNicknameController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Enter New Nickname",
              style: Theme.of(context).textTheme.displayLarge),
          content: TextField(
            controller: _editNicknameController,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Cancel",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Save",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: () async {
                OverlayEntry loading = loadingOverlay(context);
                Overlay.of(context).insert(loading);
                bool success =
                    await setDisplayName(_editNicknameController.text, token) ??
                        false;
                loading.remove();

                if (success) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        title: Text("Success",
                            style: Theme.of(context).textTheme.displayLarge),
                        content: Text("Nickname has been changed.",
                            style: Theme.of(context).textTheme.bodyMedium),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          TextButton(
                            child: Text(
                              "OK",
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .popUntil(ModalRoute.withName("leaderboard"));
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  errorDialog(context, "Nickname taken",
                      "Please try a different name.");
                }
              },
            ),
          ],
        );
      },
    ).then((value) => getData());
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    _editNicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return DefaultPage(
        backflag: true,
        child: (loading)
            ? const Center(child: CircularProgressIndicator())
            : Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                height: screenHeight * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GradBox(
                      width: screenWidth * 0.9,
                      height: 120,
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("YOUR POSITION:",
                                  style:
                                      Theme.of(context).textTheme.displaySmall),
                              SolidButton(
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer,
                                onPressed: _editNickname,
                                child: Icon(Icons.edit,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onTertiaryContainer),
                              ),
                            ],
                          ),
                          LBRow(
                              place: selfRank,
                              name: displayName,
                              points: totalPoints),
                        ],
                      ),
                    ),
                    GradBox(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.55,
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                        alignment: Alignment.topLeft,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("LEADERBOARD",
                                  style:
                                      Theme.of(context).textTheme.displayLarge),
                              Text(
                                "Scroll to see the whole board!",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                child: ListView.builder(
                                  itemCount: lbData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return LBRow(
                                        place: lbData[index].rank,
                                        name: lbData[index].displayName,
                                        points: lbData[index].totalPoints);
                                  },
                                ),
                              ))
                            ]))
                  ],
                )));
  }
}

class LBRow extends StatelessWidget {
  final int place;
  final String name;
  final int points;

  const LBRow({required this.place, required this.name, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              alignment: Alignment.center,
              child: Text(
                place.toString(),
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            Expanded(child: SolidButton(text: name, onPressed: null)),
            Container(
                width: 80,
                alignment: Alignment.center,
                child: Text(
                  "$points pts",
                  style: Theme.of(context).textTheme.bodyMedium,
                ))
          ],
        ));
  }
}
