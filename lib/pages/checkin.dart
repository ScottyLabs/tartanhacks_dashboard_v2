import 'package:flutter_smart_scan/flutter_smart_scan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/models/check_in_item.dart';
import 'package:thdapp/pages/checkin_qr.dart';
import 'package:thdapp/pages/editcheckinitem.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';
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
    if (model.checkInItemsStatus == Status.loaded) model.fetchCheckInItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return DefaultPage(
        reverse: true,
        child: Consumer<CheckInItemsModel>(
          builder: (context, checkInItemsModel, child) {
            var status = checkInItemsModel.checkInItemsStatus;
            var checkInItemsList = checkInItemsModel.checkInItems;
            if (status == Status.notLoaded) {
              checkInItemsModel.fetchCheckInItems();
              return const Center(child: CircularProgressIndicator());
            }
            // Error
            else if (status == Status.error) {
              return const Center(child: Text("Error Loading Data"));
            } else {
              return Container(
                  alignment: Alignment.center,
                  height: screenHeight * 0.78,
                  child: Column(
                    children: [
                      Expanded(flex: 1, child: Header()),
                      Expanded(flex: 2, child: CheckInEvents())
                    ],
                  ));
            }
          },
        ));
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var isAdmin = Provider.of<CheckInItemsModel>(context).isAdmin;
    var points = Provider.of<CheckInItemsModel>(context).points;
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 15, 0),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    borderRadius: const BorderRadius.all(Radius.circular(16))),
                child: QrImage(
                  data: id,
                  version: QrVersions.auto,
                  foregroundColor: isLight
                      ? Theme.of(context).colorScheme.secondary
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
  const PointsHeader(this.points);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          "CHECKIN",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          "Points earned:",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "$points pts",
          style: Theme.of(context).textTheme.displayMedium,
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "CHECKIN",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          "Admin Dashboard",
          style: Theme.of(context).textTheme.bodyMedium,
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: CheckInEventList(checkInItemsList)),
            const SizedBox(
              height: 9,
            ),
            if (editable)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GradBox(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const EditCheckInItemPage(null)))
                  },
                  curvature: 12,
                  child: Text(
                    "NEW CHECKIN ITEM",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
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

  const CheckInEventList(this.events);

  @override
  Widget build(BuildContext context) {
    var model = Provider.of<CheckInItemsModel>(context);
    var editable = model.isAdmin;
    String userID = model.userID;
    bool isAdmin = editable;
    var hasCheckedIn = model.hasCheckedIn;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              uid = await FlutterBarcodeScanner.scanBarcode(
                  '#ff6666', 'Cancel', true, ScanMode.QR);
            } else {
              uid = userID;
              checkInItemId = await FlutterBarcodeScanner.scanBarcode(
                  '#ff6666', 'Cancel', true, ScanMode.QR);
            }
            if (uid != "" &&
                checkInItemId != "") {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 2,
                      )));
              try {
                if (uid != "-1" && checkInItemId != "-1") {
                  await model.checkInUser(checkInItemId, uid);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Checked in for ${events[index].name}!"),
                  ));
                }
              } on Exception {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Could not check in. Please ensure that the QR code is correct."),
                ));
              } finally {
                Navigator.pop(context);
                model.fetchCheckInItems();
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Invalid Scan, please try again."),
              ));
            }
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
    );
  }
}

class CheckInEventListItem extends StatelessWidget {
  final String name;
  final bool isChecked;

  final bool enabled;
  final Function onCheck;
  final Function onTap;
  final int points;

  const CheckInEventListItem(
      {required this.name,
      required this.isChecked,
      required this.enabled,
      required this.onTap,
      required this.onCheck,
      required this.points});

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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
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
                        .displayLarge
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
                                  padding: const EdgeInsets.all(9),
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
                          Flexible(
                            child: Text(
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          const SizedBox(
            width: 15,
          ),
          // Button
          Expanded(
            flex: 20,
            child: SolidButton(
              onPressed: onTap,
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
            ),
          )
        ],
      ),
    );
  }
}
