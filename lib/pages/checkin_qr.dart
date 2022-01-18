
import 'package:barras/barras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';
import 'custom_widgets.dart';

class QRPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;


    final _eventIDController = TextEditingController();

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

  final _eventIDController;

  IDCheckInHeader(this._eventIDController);

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
          controller: _eventIDController,
          enableSuggestions: false,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 5,),
        Align(
          alignment: Alignment.bottomRight,
          child: SolidButton(
            onPressed: () async {
              String id = _eventIDController.text;
              if (id != null && id != "") {
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        )));
                try {
                  // TODO Error handling doesn't actually work due to the backend endpoint bad request issue
                  await Provider.of<CheckInItemsModel>(context, listen: false).selfCheckIn(id);
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text("Checked in!"),
                  // ));
                } on Exception catch (e) {
                  print(e);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Error checking in"),
                  ));
                } finally {Navigator.pop(context);}
              }
            },
            child: Icon(
              Icons.keyboard_return_rounded,
              color: Colors.white,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "YOUR QR CODE",
          style: Theme.of(context).textTheme.headline1,
        ),

        SizedBox(height: 8,),
        GradBox(
          child: QrImage(
            data: id,
            version: QrVersions.auto,
            foregroundColor: Colors.black,
          ),
        ),
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


