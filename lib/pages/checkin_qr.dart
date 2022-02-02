
import 'package:barras/barras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';
import 'custom_widgets.dart';
import '../theme_changer.dart';


class QRPage extends StatefulWidget {

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final _eventIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return Scaffold(
        body: Container(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: screenHeight),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TopBar(backflag: true),
                        Stack(
                          children: [
                            Column(children: [
                              SizedBox(height: screenHeight * 0.05),
                              CustomPaint(
                                  size: Size(screenWidth, screenHeight * 0.75),
                                  painter: CurvedTop(
                                      color1: Theme.of(context)
                                          .colorScheme
                                          .secondaryVariant,
                                      color2:
                                      Theme.of(context).colorScheme.primary,
                                      reverse: true)),
                            ]),
                            Container(
                                alignment: Alignment.center,
                                height: screenHeight * 0.78,
                                padding: EdgeInsets.fromLTRB(35, 20, 35, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    IDCheckInHeader(_eventIDController),
                                    QREnlarged(onPressed: () async {
                                      final String id = await Barras.scan(context);
                                      _eventIDController.value = TextEditingValue(text: id);
                                    },)
                                  ],
                                ))
                          ],
                        )
                      ],
                    )))));
  }
}

class IDCheckInHeader extends StatelessWidget {

  final TextEditingController eventIDController;

  IDCheckInHeader(this.eventIDController);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Check in with event ID",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
            fontSize: 20
          ),
        ),
        SizedBox(height: 10,),
        TextField(
          controller: eventIDController,
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 5,),
        Align(
          alignment: Alignment.bottomRight,
          child: SolidButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              String snackBarText = "";
              String id = eventIDController.text;
              var model = Provider.of<CheckInItemsModel>(context, listen: false);
              if (id != null && id != "") {
                try {
                  var contains = model.checkInItems.any((val) => val.id == id);
                  if (!contains) snackBarText = "Invalid scan or item id";
                  else {
                    String name = model.checkInItems.firstWhere((val) => val.id == id).name;

                    // Confirmation dialog
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) {
                          bool isLoading = false;
                          return StatefulBuilder(
                              builder: (context, setState) {
                                return isLoading ? Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ) : AlertDialog(
                                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                  title: Text("Confirm Check In"),
                                  content: RichText(
                                    text: TextSpan(
                                        text: "You are checking in to ",
                                        children: [
                                          TextSpan(
                                              text: "$name. \n\n",
                                              style: TextStyle(fontWeight: FontWeight.bold)
                                          ),
                                          TextSpan(text: "Ensure that you have selected the correct event before confirming you attendance.")
                                        ]
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancel"),
                                      onPressed: () => Navigator.pop(dialogContext),
                                    ),
                                    TextButton(
                                        child: Text("Confirm"),
                                        onPressed: () async {
                                          setState(() {isLoading = true;});
                                          await model.selfCheckIn(id);
                                          Navigator.pop(context);
                                          snackBarText = "Checked in to $name!";
                                          eventIDController.clear();
                                        }
                                    )
                                  ],
                                );
                              }
                          );
                        }
                    );
                  }
                } on Exception catch (e) {
                  print(e);
                  snackBarText = "Error checking in";
                  Navigator.pop(context);
                } finally {
                  if (snackBarText != "") ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(snackBarText),
                      duration: Duration(seconds: 1),
                  ));
                }
              }
            },
            child: Icon(
              Icons.keyboard_return_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        )
      ],
    );
  }
}

class QREnlarged extends StatelessWidget {

  final Function onPressed;

  QREnlarged({this.onPressed});

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
          style: Theme.of(context).textTheme.headline1,
        ),

        SizedBox(height: 8,),
        DecoratedBox(
                decoration: BoxDecoration(
                    color: isLight?Theme.of(context).colorScheme.onPrimary:Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: QrImage(
                  data: id,
                  version: QrVersions.auto,
                  foregroundColor: isLight?Theme.of(context).accentColor:Theme.of(context).colorScheme.onPrimary,
                ),
                )),
        SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 45,
                child: SolidButton(

                  onPressed: onPressed,
                  text: "Scan Event ID",
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}


