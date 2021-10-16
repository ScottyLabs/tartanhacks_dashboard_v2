import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'custom_widgets.dart';

class EditCheckInItemPage extends StatelessWidget {

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
                                  child: CheckInItemForm(),
                                ))
                          ],
                        )
                      ],
                    )))));
  }
}

class CheckInItemForm extends StatefulWidget {

  @override
  _CheckInItemFormState createState() => _CheckInItemFormState();
}

class _CheckInItemFormState extends State<CheckInItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _unitsController = TextEditingController();
  final _limitController = TextEditingController();
  final _pointsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NEW CHECKIN ITEM",
                style: Theme.of(context).textTheme.headline1,
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  label: Text("Name")
                ),
                style: Theme.of(context).textTheme.bodyText2,
                enableSuggestions: false,
              )
            ],
          ),
        ));
  }
}

class EditCheckInFormField extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}





