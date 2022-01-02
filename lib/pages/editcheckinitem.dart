import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:thdapp/models/check_in_item.dart';
import 'custom_widgets.dart';

class EditCheckInItemPage extends StatelessWidget {
  final CheckInItem checkInItem;

  EditCheckInItemPage(this.checkInItem);

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
                                padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                                child: GradBox(
                                  curvature: 20,
                                  padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                                  child: CheckInItemForm(checkInItem),
                                ))
                          ],
                        )
                      ],
                    )))));
  }
}

class CheckInItemForm extends StatefulWidget {
  final CheckInItem checkInItem;

  CheckInItemForm(this.checkInItem);

  @override
  _CheckInItemFormState createState() => _CheckInItemFormState();
}

class _CheckInItemFormState extends State<CheckInItemForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> accessLevels = ["ALL", "SPONSORS_ONLY",
    "PARTICIPANTS_ONLY", "ADMINS_ONLY"];
  
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _pointsController = TextEditingController();
  bool active;
  String accessLevel;

  DateTime startDate;
  DateTime endDate;

  @override
  void initState() {
    super.initState();
    _nameController.value = TextEditingValue(text: widget.checkInItem.name ?? "");
    _descController.value = TextEditingValue(text: widget.checkInItem.description ?? "");
    _pointsController.value = TextEditingValue(text: widget.checkInItem.points.toString() ?? "");

    startDate = DateTime.fromMicrosecondsSinceEpoch(widget.checkInItem?.startTime);
    endDate = DateTime.fromMicrosecondsSinceEpoch(widget.checkInItem?.endTime);
    _startDateController.value = TextEditingValue(text: DateFormat.yMMMd('en_US').format(startDate));
    _startTimeController.value = TextEditingValue(text: DateFormat.Hm('en_US').format(startDate));
    _endDateController.value = TextEditingValue(text: DateFormat.yMMMd('en_US').format(endDate));
    _endTimeController.value = TextEditingValue(text: DateFormat.Hm('en_US').format(endDate));

    active = widget.checkInItem.active ?? false;
    accessLevel = widget.checkInItem.accessLevel ?? accessLevels[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.checkInItem == null ? "NEW CHECKIN ITEM" : "EDIT CHECKIN ITEM",
                  style: Theme.of(context).textTheme.headline1,
                ),
                SizedBox(height: 20,),

                // Form Fields
                EditCheckInFormField(
                  label: "Name",
                  controller: _nameController,
                ),
                EditCheckInFormField(
                  label: "Description",
                  controller: _descController,
                ),
                EditCheckInFormField(
                  label: "Start Date",
                  controller: _startDateController,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    final DateTime picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime(2023),
                    );
                    if (picked != null) {
                      _startDateController.value = TextEditingValue(
                        text: DateFormat.yMMMd('en_US').format(picked)
                      );
                    }
                  },
                ),
                EditCheckInFormField(
                  label: "Start Time",
                  controller: _startTimeController,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    TimeOfDay picked = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(startDate) ?? TimeOfDay.now()
                    );
                    if (picked != null) {
                      _startTimeController.value = TextEditingValue(
                          text: picked.format(context)
                      );
                    }
                  }
                ),
                EditCheckInFormField(
                  label: "Points",
                  controller: _pointsController,
                  keyboardType: TextInputType.number,
                ),

                // Dropdown menus
                EditCheckInDropDownFormField(
                    items: accessLevels.asMap().map((i, label) =>
                        MapEntry(i, DropdownMenuItem(
                          value: i,
                          child: Text(label),
                        ))).values.toList(),
                  label: "Access levels",
                ),
                SizedBox(height: 15,),

                // Active toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "View History",
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Transform.scale(
                      scale: 1.5,
                      child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.primary,
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          value: active,
                          onChanged: (val){
                            setState(() {
                              active = val;
                            });
                          }),
                    )
                  ],
                ),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  child: SolidButton(
                    text: "CONFIRM",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: 15,)

              ],
            ),
          )),
    );
  }
}

class EditCheckInFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final Function onTap;

  EditCheckInFormField({
    this.controller,
    this.label,
    this.keyboardType = TextInputType.text,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onTap: onTap,
          enableSuggestions: false,
          inputFormatters: keyboardType == TextInputType.number ? [
            FilteringTextInputFormatter.digitsOnly
          ] : [],
          decoration: InputDecoration(
              labelText: label
          ),
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 15,)
      ],
    );
  }
}

class EditCheckInDropDownFormField extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final String label;
  final String initial;

  EditCheckInDropDownFormField({this.items, this.label, this.initial});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          flex: 8,
          child: DropdownButtonFormField(
            onChanged: (e){},
            items: items,
            value: initial,
          ),
        )
      ],
    );
  }
}





