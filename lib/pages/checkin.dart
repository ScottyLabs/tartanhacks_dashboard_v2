import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class Checkin extends StatefulWidget {
  @override
  _CheckinState createState() => _CheckinState();
}

class _CheckinState extends State<Checkin> {
  final List<String> testEvents = ["Opening Ceremony", "Welcome Ceremony"];

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
                                height: screenHeight * 0.75,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    QRHeader(150),
                                    CheckinEventListItem(testEvents[0], false),
                                  ],
                                ))
                          ],
                        )
                      ],
                    )))));
  }
}

class QRHeader extends StatelessWidget {
  final int points;

  QRHeader(this.points);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 15, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "CHECKIN",
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "Points earned:",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                "$points pts",
                style: Theme.of(context).textTheme.headline2,
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                child: TextButton(
                    onPressed: () => {},
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.only(right: 5),
                        minimumSize: Size(0, 0)),
                    child: Text(
                      "Your QR Code",
                      // TODO: Text link style
                    )),
              ),
              // TODO: Placeholder for QR Code
              SizedBox(
                height: 150,
                width: 150,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CheckinEventList extends StatelessWidget {
  final List<String> events;

  CheckinEventList(this.events);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckinEventListItem(events[index], false);
            }));
  }
}

class CheckinEventListItem extends StatelessWidget {
  final String name;
  final bool isChecked;

  CheckinEventListItem(this.name, this.isChecked);

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                        value: isChecked,
                        onChanged: (val) => {}
                    ),
                    Text(
                      "Click to check in",
                      style: Theme.of(context).textTheme.bodyText2,
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 15,
          ),

          Expanded(
            flex: 20,
            child: CheckinItemButton(
              text: "Edit Event",
            ),
          )
        ],
      ),
    );
  }
}
