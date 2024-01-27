import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:thdapp/api.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/models/event.dart';
import 'package:thdapp/pages/events/index.dart';

// HELPER FUNCTIONS
int daysBetween(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}

double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

// MAIN WIDGET
class EditEventPage extends StatelessWidget {
  final Event event;
  final bool editable;

  const EditEventPage(this.event, {this.editable = false});

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
              child: EventItemForm(event, editable),
            )));
  }
}

class EventItemForm extends StatefulWidget {
  final Event event;
  final bool editable;

  const EventItemForm(this.event, this.editable);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventItemForm> {
  void _showDialog(String response, String title, bool result) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(response),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              style: TextButton.styleFrom(
                  // foregroundColor: const Color.fromARGB(255, 255, 75, 43),
                  ),
              onPressed: () {
                Navigator.of(context).pop();
                if (result == true) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventsHomeScreen()),
                  );
                }
              },
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void addData(Map<String, Object> newEvent) async {
    bool result = await addEvent(
        newEvent["name"] as String,
        newEvent["description"] as String,
        newEvent["startTime"] as int,
        newEvent["endTime"] as int,
        newEvent["location"] as String,
        0,
        0,
        newEvent["platform"] as String,
        newEvent["platformUrl"] as String);

    if (result == true) {
      _showDialog('Your event was successfully saved!', 'Success', result);
    } else {
      _showDialog('There was an error. Please try again.', 'Error.', result);
    }
  }

  void editData(Map<String, Object> newEvent) async {
    bool result = await editEvent(
        newEvent["id"] as String,
        newEvent["name"] as String,
        newEvent["description"] as String,
        newEvent["startTime"] as int,
        newEvent["endTime"] as int,
        newEvent["location"] as String,
        0,
        0,
        newEvent["platform"] as String,
        newEvent["platformUrl"] as String);

    if (result == true) {
      _showDialog('Your event was successfully saved!', 'Success', result);
    } else {
      _showDialog('There was an error. Please try again.', 'Error.', result);
    }
  }

  final _formKey = GlobalKey<FormState>();
  final List<String> platforms = [
    "IN_PERSON",
    "ZOOM",
    "HOPIN",
    "DISCORD",
    "OTHER"
  ];

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _linkController = TextEditingController();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _locController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();

  late bool newItem;
  late String platform;

  late DateTime startDate;
  late DateTime endDate;

  late TimeOfDay startTime;
  late TimeOfDay endTime;

  @override
  void initState() {
    super.initState();

    Event item = widget.event;
    _nameController.value = TextEditingValue(text: widget.event.name);
    _descController.value = TextEditingValue(text: widget.event.description);
    _linkController.value = TextEditingValue(text: widget.event.platformUrl);
    _locController.value = TextEditingValue(text: widget.event.location);

    startDate = DateTime.fromMicrosecondsSinceEpoch(widget.event.startTime);
    endDate = DateTime.fromMicrosecondsSinceEpoch(widget.event.endTime);
    startTime = TimeOfDay.fromDateTime(startDate);
    endTime = TimeOfDay.fromDateTime(endDate);

    _startDateController.value =
        TextEditingValue(text: DateFormat.yMMMd('en_US').format(startDate));
    _startTimeController.value =
        TextEditingValue(text: DateFormat.Hm('en_US').format(startDate));
    _endDateController.value =
        TextEditingValue(text: DateFormat.yMMMd('en_US').format(endDate));
    _endTimeController.value =
        TextEditingValue(text: DateFormat.Hm('en_US').format(endDate));

    newItem = false;
    platform = item.platform;
    }

  @override
  Widget build(BuildContext context) {
    var editable = widget.editable;
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event == null
                    ? "NEW EVENT"
                    : editable
                        ? "EDIT EVENT"
                        : "EVENT DETAILS",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(
                height: 20,
              ),

              // Form Fields
              EditEventFormField(
                label: "Name",
                controller: _nameController,
                editable: editable,
              ),
              EditEventFormField(
                label: "Description",
                controller: _descController,
                editable: editable,
              ),
              if (editable)
                EditEventDropDownFormField(
                  items: platforms
                      .asMap()
                      .map((i, label) => MapEntry(
                          i,
                          DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          )))
                      .values
                      .toList(),
                  label: "Platform",
                  initial: platform,
                  onChange: (val) {
                    setState(() {
                      platform = val;
                    });
                  },
                ),
              const SizedBox(
                height: 20,
              ),
              EditEventFormField(
                label: "Location",
                controller: _locController,
                editable: editable,
                validator: (value) {
                  if (value == null || value.isEmpty && platform == "IN_PERSON") {
                    return "Location is required";
                  }
                  return null;
                },
              ),
              EditEventFormField(
                label: "Event URL",
                controller: _linkController,
                editable: editable,
                validator: (value) {
                  if (value ==  null || value.isEmpty && platform != "IN_PERSON") {
                    return "URL is required";
                  }
                  return null;
                },
              ),
              EditEventFormField(
                label: "Start Date",
                controller: _startDateController,
                editable: editable,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: startDate ?? DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  _startDateController.value = TextEditingValue(
                      text: DateFormat.yMMMd('en_US').format(picked!));

                  startDate = picked;
                                },
              ),
              EditEventFormField(
                label: "End Date",
                controller: _endDateController,
                editable: editable,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Cannot be empty';
                  }
                  if (daysBetween(startDate, endDate) < 0) {
                    return 'End date must be after start date';
                  }
                                  return null;
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: endDate ?? DateTime.now(),
                    firstDate: endDate ?? DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  _endDateController.value = TextEditingValue(
                      text: DateFormat.yMMMd('en_US').format(picked!));
                  endDate = picked;
                                },
              ),

              EditEventFormField(
                  label: "Start Time",
                  controller: _startTimeController,
                  editable: editable,
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: startTime ?? TimeOfDay.now());
                    _startTimeController.value =
                        TextEditingValue(text: picked!.format(context));

                    startTime = picked;
                                    }),
              EditEventFormField(
                  label: "End Time",
                  controller: _endTimeController,
                  editable: editable,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Cannot be empty';
                    }
                    if (daysBetween(startDate, endDate) == 0) {
                      if (toDouble(startTime) > toDouble(endTime)) {
                        return 'End time must be after start time';
                      }
                    }
                                      return null;
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

              // Dropdown menus

              if (editable)
                const SizedBox(
                  height: 15,
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
                            startDate.year,
                            startDate.month,
                            startDate.day,
                            startTime.hour,
                            startTime.minute);
                        DateTime endDateTime = DateTime(
                            endDate.year,
                            endDate.month,
                            endDate.day,
                            endTime.hour,
                            endTime.minute);

                        // TODO maybe add some loading indicator?
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                    child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                )));
                        if (newItem) {
                          addData({
                            "name": _nameController.text,
                            "description": _descController.text,
                            "startTime":
                                startDateTime.toUtc().microsecondsSinceEpoch,
                            "endTime":
                                endDateTime.toUtc().microsecondsSinceEpoch,
                            "platform": platform,
                            "platformUrl": _linkController.text,
                            "location": _locController.text
                          });
                        } else {
                          editData({
                            "id": widget.event.id,
                            "name": _nameController.text,
                            "description": _descController.text,
                            "startTime":
                                startDateTime.toUtc().microsecondsSinceEpoch,
                            "endTime":
                                endDateTime.toUtc().microsecondsSinceEpoch,
                            "platform": platform,
                            "platformUrl": _linkController.text,
                            "location": _locController.text
                          });
                        }
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

class EditEventFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final void Function()? onTap;
  final bool editable;
  final String? Function(String?)? validator;

  const EditEventFormField(
      {required this.controller,
      required this.label,
      required this.onTap,
      required this.editable,
      required this.validator,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
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
                return null;
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

class EditEventDropDownFormField extends StatelessWidget {
  final List<DropdownMenuItem> items;
  final String label;
  final String initial;

  final void Function(dynamic) onChange;

  const EditEventDropDownFormField(
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
            style: Theme.of(context).textTheme.bodyMedium,
            dropdownColor: Theme.of(context).colorScheme.surface,
            onChanged: onChange,
            items: items,
            value: initial,
          ),
        )
      ],
    );
  }
}
