import 'package:flutter/material.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';

class ScanConfigPage extends StatelessWidget {
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
            height: screenHeight * 0.78,
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ScanConfigBox()],
            )));
  }
}

class ScanConfigBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GradBox(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      curvature: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "SCAN CONFIG",
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 40,
          ),
          Text(
            "Check In Item",
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(
            height: 15,
          ),
          DropdownButtonFormField(
            items: [
              DropdownMenuItem(
                child: Text(
                  "Ctrl+F - Working with your team",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            ],
            onChanged: (value) {},
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "View History",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    value: false,
                    onChanged: (val) {}),
              )
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Self-checkin",
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                    side: BorderSide(
                        color: Theme.of(context).colorScheme.primary, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    value: false,
                    onChanged: (val) {}),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              height: 45,
              width: 160,
              child: SolidButton(
                text: "Confirm",
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
