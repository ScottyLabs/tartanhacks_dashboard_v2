import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/loading/LoadingOverlay.dart';
import 'package:thdapp/providers/user_info_provider.dart';

import 'team_api.dart';
import 'view_team.dart';
import '../models/team.dart';

class TeamTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const TeamTextField(this.controller, this.label);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      style: Theme.of(context).textTheme.bodyMedium,
      controller: controller,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return "Cannot be empty";
        }
        return null;
      },
    );
  }
}

class IsVisibleCheckBox extends StatelessWidget {
  final bool visibility;
  final void Function(dynamic) onTap;

  const IsVisibleCheckBox(this.visibility, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("Team Visibility"),
        Checkbox(
          activeColor: Theme.of(context).colorScheme.secondary,
          value: visibility,
          onChanged: onTap,
        )
      ],
    );
  }
}

class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController yourNameController = TextEditingController();
  TextEditingController teamNameController = TextEditingController();
  TextEditingController teamDescController = TextEditingController();
  TextEditingController inviteMemberController = TextEditingController();

  bool visibility = true;
  String buttonText = "Create Team";
  bool hasTeam = false;

  void getData() {
    hasTeam = Provider.of<UserInfoModel>(context, listen: false).hasTeam;
    if (hasTeam) {
      Team team = Provider.of<UserInfoModel>(context, listen: false).team!;
      visibility = team.visible;
      teamNameController.text = team.name;
      teamDescController.text = team.description;
      buttonText = "Edit Team";
    }
  }

  @override
  initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    yourNameController.dispose();
    teamNameController.dispose();
    teamDescController.dispose();
    inviteMemberController.dispose();
    super.dispose();
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
            child: GradBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.75,
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Text("TEAM INFO",
                                style: Theme.of(context).textTheme.displayLarge),
                            const SizedBox(height: 10),
                            Text("Basic Info",
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 15),
                            TeamTextField(teamNameController, "Team Name"),
                            const SizedBox(height: 20),
                            TeamTextField(teamDescController, "Team Desc"),
                            const SizedBox(height: 20),
                            IsVisibleCheckBox(visibility, (val) {
                              visibility = val ?? false;
                              setState(() {});
                            }),
                          ],
                        ),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: SolidButton(
                                text: buttonText,
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    OverlayEntry loading =
                                        LoadingOverlay(context);
                                    Overlay.of(context).insert(loading);
                                    String token = Provider.of<UserInfoModel>(
                                            context,
                                            listen: false)
                                        .token;
                                    String id = Provider.of<UserInfoModel>(
                                            context,
                                            listen: false)
                                        .id;

                                    String teamName = teamNameController.text;
                                    String teamDesc = teamDescController.text;

                                    Response response = hasTeam
                                        ? await editTeam(teamName, teamDesc,
                                            visibility, token)
                                        : await createTeam(teamName, teamDesc,
                                            visibility, token);

                                    if (response.statusCode != 200) {
                                      loading.remove();
                                      String errorMessage = jsonDecode(
                                              response.body)["message"] ??
                                          "Failed to create team.";
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(errorMessage),
                                      ));
                                      return;
                                    }

                                    if (!hasTeam) {
                                      await promoteToAdmin(id, token);
                                    }
                                    await Provider.of<UserInfoModel>(context,
                                            listen: false)
                                        .fetchUserInfo();
                                    loading.remove();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewTeam(),
                                          settings: const RouteSettings(
                                            arguments: "",
                                          )),
                                    );
                                  }
                                },
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiaryContainer))
                      ]),
                ))));
  }
}
