import 'package:barras/barras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thdapp/models/check_in_item.dart';
import 'package:thdapp/pages/checkin_qr.dart';
import 'package:thdapp/pages/editcheckinitem.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';
import 'custom_widgets.dart';
import '../theme_changer.dart';

class CheckIn extends StatefulWidget {
  @override
  State<CheckIn> createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  @override
  void initState() {
    // Refresh on page load
    var model = Provider.of<CheckInItemsModel>(context, listen: false);
    if (model.checkInItemsStatus == Status.Loaded) model.fetchCheckInItems();
    super.initState();
  }

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
                        TopBar(),
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
                            Consumer<CheckInItemsModel>(
                              builder: (context, checkInItemsModel, child) {
                                var status =
                                    checkInItemsModel.checkInItemsStatus;
                                var checkInItemsList =
                                    checkInItemsModel.checkInItems;
                                if (status == Status.NotLoaded ||
                                    checkInItemsList == null) {
                                  checkInItemsModel.fetchCheckInItems();
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                // Error
                                else if (status == Status.Error) {
                                  return Center(
                                      child: Text("Error Loading Data"));
                                } else {
                                  return Container(
                                      alignment: Alignment.center,
                                      height: screenHeight * 0.78,
                                      child: Column(
                                        children: [
                                          Expanded(flex: 1, child: Header()),
                                          Expanded(
                                              flex: 2, child: CheckInEvents())
                                        ],
                                      ));
                                }
                              },
                            )
                          ],
                        )
                      ],
                    )))));
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isAdmin = Provider.of<CheckInItemsModel>(context).isAdmin;
    var points = Provider.of<CheckInItemsModel>(context).points;
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 15, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            isAdmin ? [AdminHeader()] : [PointsHeader(points), QRHeader()],
      ),
    );
  }
}

class QRHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isLight = Provider.of<ThemeChanger>(context, listen: false).getTheme ==
        lightTheme;

    String id = Provider.of<CheckInItemsModel>(context).userID;
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QRPage()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Text(
              "Get Checked In",
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 16),
            ),
          ),
          SizedBox(
            height: 125,
            width: 125,
            child: DecoratedBox(
                decoration: BoxDecoration(
                    color: isLight
                        ? Theme.of(context).colorScheme.onPrimary
                        : Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.all(Radius.circular(16))),
                child: QrImage(
                  data: id,
                  version: QrVersions.auto,
                  foregroundColor: isLight
                      ? Theme.of(context).accentColor
                      : Theme.of(context).colorScheme.onPrimary,
                )),
          )
        ],
      ),
    );
  }
}

class PointsHeader extends StatelessWidget {
  final int points;
  PointsHeader(this.points);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 5,
        ),
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
    );
  }
}

class AdminHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "CHECKIN",
          style: Theme.of(context).textTheme.headline1,
        ),
        SizedBox(
          height: 2,
        ),
        Text(
          "Admin Dashboard",
          style: Theme.of(context).textTheme.bodyText2,
        )
      ],
    );
  }
}

class CheckInEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var model = Provider.of<CheckInItemsModel>(context);
    var editable = model.isAdmin;
    var checkInItemsList = model.checkInItems;
    return RefreshIndicator(
      onRefresh: model.fetchCheckInItems,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: CheckInEventList(checkInItemsList)),
            SizedBox(
              height: 9,
            ),
            if (editable)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GradBox(
                  child: Text(
                    "NEW CHECKIN ITEM",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        ?.copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditCheckInItemPage(null)))
                  },
                  curvature: 12,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class CheckInEventList extends StatelessWidget {
  final List<CheckInItem> events;

  CheckInEventList(this.events);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<CheckInItemsModel>(context);
    var editable = model.isAdmin;
    String userID = model.userID;
    bool isAdmin = editable;
    var hasCheckedIn = model.hasCheckedIn;
    return Container(
        child: ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      itemCount: events.length,
      itemBuilder: (BuildContext context, int index) {
        return CheckInEventListItem(
          name: events[index].name,
          points: events[index].points,
          isChecked: editable ? false : hasCheckedIn[events[index].id],
          enabled: events[index].enableSelfCheckIn,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditCheckInItemPage(events[index])));
          },
          onCheck: () async {
            String uid = "";
            String checkInItemId = "";
            if (isAdmin) {
              checkInItemId = events[index].id;
              uid = await Barras.scan(context);
            } else {
              uid = userID;
              checkInItemId = await Barras.scan(context);
            }
            if (uid != null &&
                uid != "" &&
                checkInItemId != null &&
                checkInItemId != "") {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 2,
                      )));
              try {
                await model.checkInUser(events[index].id, uid);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Checked in for " + events[index].name + "!"),
                ));
              } on Exception catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(e.toString().substring(11)),
                ));
              } finally {
                Navigator.pop(context);
                model.fetchCheckInItems();
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Invalid Scan, please try again."),
              ));
            }
          },
        );
      },
      separatorBuilder: (context, index) => SizedBox(
        height: 15,
      ),
    ));
  }
}

class CheckInEventListItem extends StatelessWidget {
  final String name;
  final bool isChecked;

  final bool enabled;
  final Function onCheck;
  final Function onTap;
  final int points;

  CheckInEventListItem(
      {this.name,
      this.isChecked,
      this.enabled,
      this.onTap,
      this.onCheck,
      this.points});

  @override
  Widget build(BuildContext context) {
    var editable = Provider.of<CheckInItemsModel>(context).isAdmin;
    bool isAdmin = editable;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Checkbox
          Expanded(
            flex: 80,
            child: GradBox(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              curvature: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        ?.copyWith(fontSize: 23),
                  ),
                  InkWell(
                    onTap: () {
                      if ((!isChecked && enabled) || isAdmin) onCheck();
                    },
                    child: IgnorePointer(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          editable
                              ? Padding(
                                  padding: EdgeInsets.all(9),
                                  child: Icon(
                                    Icons.linked_camera,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                              : Transform.scale(
                                  scale: 1.4,
                                  child: Checkbox(
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    value: isChecked,
                                    onChanged: null,
                                  ),
                                ),
                          Text(
                            isChecked
                                ? "You are checked in - ${points}pts"
                                : isAdmin
                                    ? "Scan Users in - ${points}pts"
                                    : enabled
                                        ? "Click to Check in - ${points}pts"
                                        : "Check in at venue - ${points}pts",
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                            style: Theme.of(context).textTheme.bodyText2,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          SizedBox(
            width: 15,
          ),
          // Button
          Expanded(
            flex: 20,
            child: SolidButton(
              child: FittedBox(
                child: Text(
                  editable ? "Edit\nItem" : "View\nItem",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  maxLines: 2,
                ),
              ),
              onPressed: onTap,
            ),
          )
        ],
      ),
    );
  }
}
