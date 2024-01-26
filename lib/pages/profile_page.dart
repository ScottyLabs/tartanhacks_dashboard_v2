import 'dart:io';

import 'package:flutter/material.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/components/loading/LoadingOverlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile.dart';

import '../models/team.dart';
import 'package:thdapp/api.dart';
import 'package:url_launcher/url_launcher.dart';

// getting to the gallery
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePage extends StatefulWidget {
  final Map? bookmarks;

  const ProfilePage({this.bookmarks});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences prefs;
  bool isAdmin = false;
  late String id;
  late String token;

  late Profile userData;
  late String teamName;
  bool isSelf = false;
  late CroppedFile? profilePicFile;

  final _editNicknameController = TextEditingController();

  void getData() async {
    prefs = await SharedPreferences.getInstance();

    isAdmin = prefs.getBool('admin')!;
    token = prefs.getString('token')!;

    if (id == null) {
      id = prefs.getString('id')!;
      isSelf = true;
    }

    userData = await getProfile(id, token);

    Team? userTeam = await getTeamById(id, token);
    if (userTeam != null) {
      teamName = userTeam.name;
    } else {
      teamName = "No team";
    }

    setState(() {});
  }

  _launchResume() async {
    String url = userData.resume;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      errorDialog(context, "Error", 'Could not launch resume url.');
    }
  }

  _launchGithub() async {
    String url = "https://github.com/" + userData.github;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      errorDialog(context, "Error", 'Could not launch GitHub url.');
    }
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
              style: Theme.of(context).textTheme.headline1),
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
                OverlayEntry loading = LoadingOverlay(context);
                Overlay.of(context).insert(loading);
                bool success =
                    await setDisplayName(_editNicknameController.text, token);
                loading.remove();

                if (success == null) {
                  errorDialog(
                      context, "Error", "An error occurred. Please try again.");
                } else if (success) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        title: Text("Success",
                            style: Theme.of(context).textTheme.headline1),
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
                                  .popUntil(ModalRoute.withName("profpage"));
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

  _editPicture() async {
    profilePicFile = null;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                title: Text("Profile Picture:",
                    style: Theme.of(context).textTheme.headline1),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: Align(
                  alignment: Alignment.center,
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ButtonBar(alignment: MainAxisAlignment.center, children: [
                        SolidButton(
                            text: "Delete Uploaded Picture",
                            onPressed: () async {
                              if (Image.network(userData.profilePicture) !=
                                  null) {
                                OverlayEntry loading = LoadingOverlay(context);
                                Overlay.of(context).insert(loading);
                                bool didUpload = await deleteProfilePic(token);
                                if (!didUpload) {
                                  errorDialog(context, "Error",
                                      "An error occurred. Please try again.");
                                } else {
                                  loading.remove();
                                }
                              }
                            })
                      ]),
                      AspectRatio(
                          aspectRatio: 1.0 / 1.0,
                          child: profilePicFile != null
                              ? Image.file(profilePicFile)
                              : Container(
                                  color: Colors.black,
                                  child: Center(
                                      child: Text("No picture chosen",
                                          style: const TextStyle(
                                              color: Colors.white))))),
                      ButtonBar(alignment: MainAxisAlignment.center, children: [
                        SolidButton(
                            text: "Gallery",
                            onPressed: () {
                              _getImage(ImageSource.gallery, setState);
                            }),
                        SolidButton(
                            text: "Camera",
                            onPressed: () {
                              _getImage(ImageSource.camera, setState);
                            }),
                        SolidButton(
                            text: "Crop",
                            onPressed: () {
                              _cropPicture(setState);
                            }),
                      ]),
                    ],
                  ),
                ),
                actions: <Widget>[
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
                      if (profilePicFile != null) {
                        OverlayEntry loading = LoadingOverlay(context);
                        Overlay.of(context).insert(loading);
                        bool didUpload =
                            await uploadProfilePic(profilePicFile, token);
                        if (!didUpload) {
                          errorDialog(context, "Error",
                              "An error occurred. Please try again.");
                        } else {
                          loading.remove();
                        }
                      }
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName("profpage"));
                    },
                  )
                ]);
          });
        }).then((value) => getData());
  }

  _cropPicture(setState) async {
    if (profilePicFile != null) {
      profilePicFile = await ImageCropper().cropImage(
        sourcePath: profilePicFile != null
            ? profilePicFile.path
            : Uri.parse(userData.profilePicture).path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
      );
      setState(() {});
    } else {
      errorDialog(context, "Error", 'No file uploaded from phone');
    }
  }

  _getImage(ImageSource source, setState) async {
    profilePicFile = await ImagePicker.pickImage(source: source);
    setState(() {});
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

    if (ModalRoute.of(context) != null) {
      id = ModalRoute.of(context).settings.arguments as String;
    }

    return DefaultPage(
        backflag: true,
        reverse: true,
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: GradBox(
                width: screenWidth * 0.9,
                height: screenHeight * 0.75,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: SizedBox(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Text(
                          "HACKER PROFILE",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        if (!isSelf && id != null)
                          Expanded(
                              child: IconButton(
                                  icon: widget.bookmarks.containsValue(id)
                                      ? const Icon(Icons.bookmark)
                                      : const Icon(Icons.bookmark_outline),
                                  color: Theme.of(context).colorScheme.primary,
                                  iconSize: 40.0,
                                  onPressed: () async {
                                    if (widget.bookmarks.containsValue(id)) {
                                      String bmId = widget.bookmarks.keys
                                          .firstWhere(
                                              (k) => widget.bookmarks[k] == id,
                                              orElse: () => null);
                                      deleteBookmark(token, bmId);
                                      widget.bookmarks.remove(bmId);
                                    } else {
                                      String bmId =
                                          await addBookmark(token, id);
                                      widget.bookmarks[bmId] = id;
                                    }
                                    setState(() {});
                                  }))
                      ]),
                      if (userData == null)
                        const SizedBox(
                            height: 100,
                            child: Center(child: CircularProgressIndicator()))
                      else
                        Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  height: 150,
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            if (isSelf) {
                                              _editPicture();
                                            }
                                          },
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Container(
                                                  color: Colors.black,
                                                  child: Center(
                                                      child: userData
                                                                  .profilePicture !=
                                                              null
                                                          ? Image.network(
                                                              userData
                                                                  .profilePicture,
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace
                                                                      stackTrace) {
                                                              return Image.asset(
                                                                  'lib/logos/defaultpfp.PNG');
                                                            })
                                                          : Image.asset(
                                                              'lib/logos/defaultpfp.PNG')),
                                                )),
                                          )),
                                      const SizedBox(width: 25),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(userData.firstName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall),
                                          Text(userData.lastName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displaySmall),
                                          Text('"' + userData.displayName + '"',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                          Text(teamName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                        ],
                                      ))
                                    ],
                                  )),
                              if (isSelf)
                                SolidButton(
                                  text: "Edit Nickname",
                                  onPressed: _editNickname,
                                ),
                              const SizedBox(height: 10),
                              Text(userData.school,
                                  style:
                                      Theme.of(context).textTheme.displaySmall),
                              Text(userData.major,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Text(
                                  "Expected graduation " +
                                      userData.graduationYear.toString(),
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                              Row(
                                children: [
                                  ButtonBar(
                                    children: [
                                      SolidButton(
                                        text: " Link to GitHub ",
                                        onPressed: () => _launchGithub(),
                                      ),
                                      SolidButton(
                                        text: " View Resume ",
                                        onPressed: () => _launchResume(),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                              /*SizedBox(height: 8),
                      Text("Bio:",
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                      ),
                      Container(
                          height: 100,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: darken(Theme
                                .of(context)
                                .colorScheme
                                .surface, 0.04),
                            borderRadius: BorderRadius
                                .circular(15),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                                  "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                                  "Ut enim ad minim veniam, quis nostrud exercitation ullamco "
                                  "laboris nisi ut aliquip ex ea commodo consequat.",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                          )
                      ),
                      SizedBox(height: 8),*/
                            ])
                    ],
                  ),
                ))));
  }
}
