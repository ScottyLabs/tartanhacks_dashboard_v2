import 'package:flutter/material.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api.dart';
import '../models/prize.dart';

class EnterPrizes extends StatefulWidget {
  final String projId;
  final List enteredPrizes;
  const EnterPrizes({required this.projId, required this.enteredPrizes});

  @override
  EnterPrizesState createState() => EnterPrizesState();
}

class EnterPrizesState extends State<EnterPrizes> {
  late bool isAdmin;
  late String id;
  late String token;
  late String projId;
  List<Prize> prizes = [];
  List enteredPrizes = [];

  @override
  void initState() {
    super.initState();
    projId = widget.projId;
    enteredPrizes = widget.enteredPrizes;
    getData();
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isAdmin = prefs.getBool('admin') ?? false;
    id = prefs.getString('id') ?? "";
    token = prefs.getString('token') ?? "";

    prizes = await getPrizes();

    setState(() {});
  }

  void prizeDialog(String prizeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text("Confirmation",
              style: Theme.of(context).textTheme.displayLarge),
          content: Text(
              "Are you sure you want to enter for this prize? This action cannot be undone.",
              style: Theme.of(context).textTheme.bodyMedium),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Cancel",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "OK",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onPressed: () {
                prizeEntry(prizeId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void prizeEntry(String prizeId) async {
    bool success = await enterPrize(context, projId, prizeId, token);
    if (success) {
      enteredPrizes.add(prizeId);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final mqData = MediaQuery.of(context);
    final screenHeight = mqData.size.height;
    final screenWidth = mqData.size.width;

    return DefaultPage(
        backflag: true,
        reverse: true,
        child: Column(
          children: [
            Container(
                height: screenHeight * 0.15,
                width: screenWidth,
                padding: const EdgeInsets.fromLTRB(25, 10, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ENTER FOR PRIZE",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      "Scroll to see the full list.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  ],
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: screenHeight * 0.65),
                  child: ListView.builder(
                    itemCount: prizes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PrizeCard(
                        id: prizes[index].id,
                        name: prizes[index].name,
                        desc: prizes[index].description,
                        entered: enteredPrizes.contains(prizes[index].id),
                        entryFn: () => prizeDialog(
                          prizes[index].id,
                        ),
                      );
                    },
                  ),
                ))
          ],
        ));
  }
}

class PrizeCard extends StatelessWidget {
  String id;
  String name;
  String desc;

  bool entered;
  void Function() entryFn;

  PrizeCard(
      {required this.id,
      required this.name,
      required this.desc,
      required this.entered,
      required this.entryFn});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: GradBox(
            width: 100,
            height: 200,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.displayMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  desc,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                (entered)
                    ? SolidButton(
                        text: "  Submitted  ",
                        color: Colors.grey,
                        textColor: Colors.white,
                        onPressed: null,
                      )
                    : SolidButton(
                        text: "   Submit   ",
                        onPressed: entryFn,
                      )
              ],
            )));
  }
}
