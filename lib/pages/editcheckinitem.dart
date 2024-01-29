import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/models/check_in_item.dart';
import 'package:thdapp/providers/check_in_items_provider.dart';

// HELPER FUNCTIONS
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

// MAIN WIDGET
class EditCheckInItemPage extends StatelessWidget {
  final CheckInItem? checkInItem;

  const EditCheckInItemPage(this.checkInItem);

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
            child: GradBox(
              curvature: 20,
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
              child: CheckInItemForm(checkInItem),
            )));
  }
}

class CheckInItemForm extends StatefulWidget {
  final CheckInItem? checkInItem;

  const CheckInItemForm(this.checkInItem);

  @override
  _CheckInItemFormState createState() => _CheckInItemFormState();
}

class _CheckInItemFormState extends State<CheckInItemForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> accessLevels = [
    "ALL",
    "SPONSORS_ONLY",
    "PARTICIPANTS_ONLY",
    "ADMINS_ONLY"
  ];

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _pointsController = TextEditingController();

  late bool enableSelfCheckIn;
  late bool newItem;
  late String accessLevel;

  DateTime? startDate;
  DateTime? endDate;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  @override
  void initState() {
    super.initState();

    CheckInItem? item = widget.checkInItem;
    if (item != null) {
      _nameController.value = TextEditingValue(text: item.name);
      _descController.value = TextEditingValue(text: item.description);
      _pointsController.value = TextEditingValue(text: item.points.toString());

      startDate = DateTime.fromMicrosecondsSinceEpoch(item.startTime);
      endDate = DateTime.fromMicrosecondsSinceEpoch(item.endTime);
      startTime = TimeOfDay.fromDateTime(startDate!);
      endTime = TimeOfDay.fromDateTime(endDate!);

      _startDateController.value =
          TextEditingValue(text: DateFormat.yMMMd('en_US').format(startDate!));
      _startTimeController.value =
          TextEditingValue(text: DateFormat.Hm('en_US').format(startDate!));
      _endDateController.value =
          TextEditingValue(text: DateFormat.yMMMd('en_US').format(endDate!));
      _endTimeController.value =
          TextEditingValue(text: DateFormat.Hm('en_US').format(endDate!));

      newItem = false;
      enableSelfCheckIn = item.enableSelfCheckIn;
      accessLevel = item.accessLevel;
    } else {
      newItem = true;
      enableSelfCheckIn = false;
      accessLevel = accessLevels[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool editable = Provider.of<CheckInItemsModel>(context).isAdmin ?? false;
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.checkInItem == null
                    ? "NEW CHECKIN ITEM"
                    : editable
                        ? "EDIT CHECKIN ITEM"
                        : "EVENT DETAILS",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(
                height: 20,
              ),

              // Form Fields
              EditCheckInFormField(
                label: "Name",
                controller: _nameController,
                onTap: () {},
                validator: (String? val) {
                  return null;
                },
              ),
              EditCheckInFormField(
                label: "Description",
                controller: _descController,
                onTap: () {},
                validator: (String? val) {
                  return null;
                },
              ),
              EditCheckInFormField(
                label: "Start Date",
                controller: _startDateController,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: startDate ?? DateTime.now(),
                      firstDate: startDate ?? DateTime.now(),
                      lastDate: DateTime(2030),
                      builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                              dialogBackgroundColor:
                                  Theme.of(context).colorScheme.background),
                          child: child!));
                  if (picked != null) {
                    _startDateController.value = TextEditingValue(
                        text: DateFormat.yMMMd('en_US').format(picked));

                    startDate = picked;
                  }
                },
                validator: (String? val) {
                  return null;
                },
              ),
              EditCheckInFormField(
                label: "End Date",
                controller: _endDateController,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Cannot be empty';
                  }
                  if (startDate != null &&
                      endDate != null &&
                      daysBetween(startDate!, endDate!) < 0) {
                    return 'End date must be after start date';
                  }

                  throw Error();
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: endDate ?? DateTime.now(),
                      firstDate: endDate ?? DateTime.now(),
                      lastDate: DateTime(2030),
                      builder: (context, child) => Theme(
                          data: Theme.of(context).copyWith(
                              dialogBackgroundColor:
                                  Theme.of(context).colorScheme.background),
                          child: child!));
                  _endDateController.value = TextEditingValue(
                      text: DateFormat.yMMMd('en_US').format(picked!));
                  endDate = picked;
                },
              ),

              EditCheckInFormField(
                label: "Start Time",
                controller: _startTimeController,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: startTime ?? TimeOfDay.now());
                  _startTimeController.value =
                      TextEditingValue(text: picked!.format(context));

                  startTime = picked;
                },
                validator: (String? val) {
                  return null;
                },
              ),
              EditCheckInFormField(
                  label: "End Time",
                  controller: _endTimeController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Cannot be empty';
                    }
                    if (startTime != null &&
                        endTime != null &&
                        startDate != null &&
                        endDate != null &&
                        daysBetween(startDate!, endDate!) == 0) {
                      if (toDouble(startTime!) > toDouble(endTime!)) {
                        return 'End time must be after start time';
                      }
                    }
                    throw Error();
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: endTime ?? TimeOfDay.now());
                    _endTimeController.value =
                        TextEditingValue(text: picked!.format(context));
                    endTime = picked;
                  }),

              EditCheckInFormField(
                label: "Points",
                controller: _pointsController,
                keyboardType: TextInputType.number,
                onTap: () {},
                validator: (String? value) {
                  return null;
                },
              ),

              // Dropdown menus

              if (editable)
                EditCheckInDropDownFormField(
                  items: accessLevels
                      .asMap()
                      .map((i, label) => MapEntry(
                          i,
                          DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          )))
                      .values
                      .toList(),
                  label: "Access levels",
                  initial: accessLevel,
                  onChange: (val) {
                    setState(() {
                      accessLevel = val;
                    });
                  },
                ),
              if (editable)
                const SizedBox(
                  height: 15,
                ),

              // Active toggle
              if (editable)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Self Check In Allowed",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
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
                          value: enableSelfCheckIn,
                          onChanged: (val) {
                            setState(() {
                              enableSelfCheckIn = val!;
                            });
                          }),
                    )
                  ],
                ),

              // Submit button

              if (editable)
                SizedBox(
                  width: double.infinity,
                  child: SolidButton(
                    text: "CONFIRM",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        DateTime startDateTime = DateTime(
                            startDate!.year,
                            startDate!.month,
                            startDate!.day,
                            startTime!.hour,
                            startTime!.minute);
                        DateTime endDateTime = DateTime(
                            endDate!.year,
                            endDate!.month,
                            endDate!.day,
                            endTime!.hour,
                            endTime!.minute);

                        CheckInItemDTO updatedItem = CheckInItemDTO(
                            name: _nameController.text,
                            description: _descController.text,
                            accessLevel: accessLevel,
                            startTime:
                                startDateTime.toUtc().microsecondsSinceEpoch,
                            endTime: endDateTime.toUtc().microsecondsSinceEpoch,
                            enableSelfCheckIn: enableSelfCheckIn,
                            points: int.tryParse(_pointsController.text) ?? 0);

                        // TODO maybe add some loading indicator?
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                    child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )));
                        if (newItem) {
                          await Provider.of<CheckInItemsModel>(context,
                                  listen: false)
                              .addCheckInItem(updatedItem);
                        } else {
                          await Provider.of<CheckInItemsModel>(context,
                                  listen: false)
                              .editCheckInItem(
                                  updatedItem, widget.checkInItem!.id);
                        }
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              const SizedBox(
                height: 15,
              )
            ],
          )),
    );
  }
}

class EditCheckInFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final void Function()? onTap;

  final String? Function(String?)? validator;

  const EditCheckInFormField(
      {required this.controller,
      required this.label,
      required this.onTap,
      required this.validator,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    var editable = Provider.of<CheckInItemsModel>(context).isAdmin;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onTap: onTap,
          enabled: editable,
          validator: validator ??
              (val) {
                if (val == null || val.isEmpty) {
                  return 'Cannot be empty';
                }

                throw Error();
              },
          enableSuggestions: false,
          inputFormatters: keyboardType == TextInputType.number
              ? [FilteringTextInputFormatter.digitsOnly]
              : [],
          decoration: InputDecoration(labelText: label),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}

class EditCheckInDropDownFormField extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final String label;
  final String initial;

  final void Function(dynamic)? onChange;

  const EditCheckInDropDownFormField(
      {required this.items,
      required this.label,
      required this.initial,
      required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 8,
          child: DropdownButtonFormField(
            onChanged: onChange,
            items: items,
            value: initial,
          ),
        )
      ],
    );
  }
}
