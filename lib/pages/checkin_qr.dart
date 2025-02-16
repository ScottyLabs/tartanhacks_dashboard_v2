import 'package:flutter_smart_scan/flutter_smart_scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/models/profile.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';
import '../theme_changer.dart';

class QRPage extends StatefulWidget {
  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final _eventIDController = TextEditingController();

  late Profile userData;
  late String id;
  late String token;

  void getData() async {
    prefs = await SharedPreferences.getInstance();

    token = prefs.getString('token')!;
    id = prefs.getString('id')!;

    userData = await getProfile(id, token);

    setState(() {});
  }

  @override
  initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    String dietaryRestrictions;
    if (userData.dietaryRestrictions!.isEmpty) {
      dietaryRestrictions = "No dietary restrictions";
    } else {
      dietaryRestrictions = "Dietary restrictions: ${userData.dietaryRestrictions!.join(', ')}";
    }

    Color dietaryRestrictionsColor;
    if (userData.dietaryRestrictions!.isEmpty) {
      dietaryRestrictionsColor = const Color(0xFFF7F1E2);
    } else {
      dietaryRestrictionsColor = const Color(0xFFFF70A1);
    }

    return DefaultPage(
        backflag: true,
        reverse: true,
        child: Container(
            alignment: Alignment.center,
            height: screenHeight * 0.78,
            padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IDCheckInHeader(_eventIDController),
                Text(
                  dietaryRestrictions, 
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(color: dietaryRestrictionsColor),
                ),
                QREnlarged(
                  onPressed: () async {
                    final String id = await FlutterBarcodeScanner.scanBarcode(
                        '#ff6666', 'Cancel', true, ScanMode.QR);
                    if (!["-1", "", null].contains(id)) {
                      _eventIDController.value = TextEditingValue(text: id);
                    }
                  },
                )
              ],
            )));
  }
}

class IDCheckInHeader extends StatelessWidget {
  final TextEditingController eventIDController;

  const IDCheckInHeader(this.eventIDController);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Check in with event ID",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          controller: eventIDController,
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: SolidButton(
            color: Theme.of(context).colorScheme.tertiaryContainer,
            onPressed: () async {
              FocusScope.of(context).unfocus();
              String snackBarText = "";
              String id = eventIDController.text;
              var model =
              Provider.of<CheckInItemsModel>(context, listen: false);
              if (id != "") {
                try {
                  var contains = model.checkInItems.any((val) => val.id == id);
                  if (!contains) {
                    snackBarText = "Invalid item id";
                  } else {
                    String name = model.checkInItems
                        .firstWhere((val) => val.id == id)
                        .name;

                    // Confirmation dialog
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) {
                          bool isLoading = false;
                          return StatefulBuilder(builder: (context, setState) {
                            return isLoading
                                ? const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                                : AlertDialog(
                              backgroundColor: Theme.of(context)
                                  .scaffoldBackgroundColor,
                              title: const Text("Confirm Check In"),
                              content: RichText(
                                text: TextSpan(
                                    text: "You are checking in to ",
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    children: [
                                      TextSpan(
                                          text: "$name. \n\n",
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.bold)),
                                      const TextSpan(
                                          text:
                                          "Ensure that you have selected the correct event before confirming you attendance.")
                                    ]),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () =>
                                      Navigator.pop(dialogContext),
                                ),
                                TextButton(
                                    child: const Text("Confirm"),
                                    onPressed: () async {
                                      try {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        await model.selfCheckIn(id);
                                        Navigator.pop(context);
                                        snackBarText =
                                        "Checked in to $name!";
                                        eventIDController.clear();
                                      } on Exception catch (e) {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              e.toString().substring(11)),
                                        ));
                                      }
                                    })
                              ],
                            );
                          });
                        });
                  }
                } on Exception {
                  snackBarText = "Error checking in";
                  Navigator.pop(context);
                } finally {
                  if (snackBarText != "") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(snackBarText),
                      duration: const Duration(seconds: 1),
                    ));
                  }
                }
              }
            },
            child: Icon(
              Icons.keyboard_return_rounded,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
        )
      ],
    );
  }
}

class QREnlarged extends StatelessWidget {
  final Function onPressed;

  const QREnlarged({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    String id = Provider.of<CheckInItemsModel>(context).userID;
    var isLight = Provider.of<ThemeChanger>(context, listen: false).getTheme ==
        lightTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "YOUR QR CODE",
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: Theme.of(context).primaryColorLight),
        ),

        const SizedBox(
          height: 8,
        ),
        DecoratedBox(
            decoration: BoxDecoration(
                color: isLight
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.all(Radius.circular(16))),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: QrImageView(
                data: id,
                version: QrVersions.auto,
                eyeStyle: QrEyeStyle(
                  color: isLight
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onPrimary,
                ),
                dataModuleStyle: QrDataModuleStyle(
                  color: isLight
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            )),
        const SizedBox(
          height: 15,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Expanded(
        //       flex: 3,
        //       child: SizedBox(
        //         height: 45,
        //         child: SolidButton(

        //           onPressed: onPressed,
        //           text: "Scan Event ID",
        //         ),
        //       ),
        //     ),
        //   ],
        // )
      ],
    );
  }
}