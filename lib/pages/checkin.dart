import 'package:barras/barras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/models/check_in_item.dart';
import 'package:thdapp/pages/checkin_qr.dart';
import 'package:thdapp/pages/editcheckinitem.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';
import 'custom_widgets.dart';

class CheckIn extends StatelessWidget {

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
                            Consumer<CheckInItemsModel>(
                              builder: (context, checkInItemsModel, child) {
                                var status = checkInItemsModel.checkInItemsStatus;
                                var checkInItemsList = checkInItemsModel.checkInItems;
                                if (status==Status.NotLoaded ||
                                    checkInItemsList==null) {
                                  checkInItemsModel.fetchCheckInItems();
                                  return Center(
                                      child: CircularProgressIndicator()
                                  );
                                }
                                // Error
                                else if (status==Status.Error) {
                                  return Center(
                                      child: Text("Error Loading Data")
                                  );
                                }
                                else return Container(
                                    alignment: Alignment.center,
                                    height: screenHeight * 0.78,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Header()),
                                        Expanded(
                                            flex: 2,
                                            child: CheckInEvents()
                                        )
                                      ],
                                    )
                                  );
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
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: isAdmin ? [AdminHeader()] : [PointsHeader(points: points), QRHeader()],
      ),
    );
  }
}

class QRHeader extends StatelessWidget {
  const QRHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QRPage()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 30,
            child: Text(
              "Your QR Code",
              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 16
              ),
            ),
          ),
          // TODO: Placeholder for QR Code
          SizedBox(
            height: 150,
            width: 150,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: FutureBuilder(
                future: getCurrentUserID(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else if (snapshot.connectionState == ConnectionState.done && snapshot.data!=null)
                    return QrImage(
                      data: snapshot.data,
                      version: QrVersions.auto,
                      foregroundColor: Colors.white,
                    );
                  else return Center(child: Text("Error"),);
                },

              )
            ),
          )
        ],
      ),
    );
  }
}

class PointsHeader extends StatelessWidget {
  const PointsHeader({
    Key key,
    @required this.points,
  }) : super(key: key);

  final int points;

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
  CheckInEvents();

  @override
  Widget build(BuildContext context) {
    var editable = Provider.of<CheckInItemsModel>(context).isAdmin;
    var checkInItemsList = Provider.of<CheckInItemsModel>(context).checkInItems;
    return RefreshIndicator(
      onRefresh: Provider.of<CheckInItemsModel>(context).fetchCheckInItems,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: CheckInEventList(checkInItemsList)),
            SizedBox(height: 9,),
            if (editable) GradBox(
              child: Text(
                "NEW CHECKIN ITEM",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),
              ),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditCheckInItemPage(null))
                )
              },
              curvature: 12,
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
    var hasCheckedIn = model.hasCheckedIn;
    return Container(
        child: ListView.separated(
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            return CheckInEventListItem(
              name: events[index].name,
              isChecked: editable ? false : hasCheckedIn[events[index].id],
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditCheckInItemPage(events[index])
                ));
              },
              onCheck: (val) async {
                // Open camera to scan users if isAdmin
                if (editable) {
                  final String uid = await Barras.scan(context);
                  if (uid != null && uid != "") {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            )));
                    await model.checkInUser(events[index].id, uid);
                    Navigator.pop(context);
                  }
                }
                // Else checkInBox
                else {

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
  final Function onCheck;
  final Function onTap;

  CheckInEventListItem({
    this.name,
    this.isChecked,
    this.onTap,
    this.onCheck,
});

  @override
  Widget build(BuildContext context) {
    var editable = Provider.of<CheckInItemsModel>(context).isAdmin;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Checkbox
          Expanded(
            flex: 80,
            child: GradBox(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        editable ? Padding(
                            padding: EdgeInsets.all(9),
                          child: Icon(
                            Icons.linked_camera,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        )
                        : Transform.scale(
                          scale: 1.4,
                          child: Checkbox(
                              side: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              value: isChecked),
                        ),
                        Text(
                          isChecked ? "You are checked in" : "Click to scan in",
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      ],
                    ),
                      onTap: () => onCheck(null),
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
                    fontSize:14.0,
                    fontWeight: FontWeight.w600,
                    color:Theme.of(context).colorScheme.onPrimary,
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
