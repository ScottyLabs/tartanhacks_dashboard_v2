import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/buttons/SolidButton.dart';
import 'package:thdapp/providers/expo_config_provider.dart';
import 'package:thdapp/models/project.dart';
import 'package:thdapp/providers/user_info_provider.dart';
import 'package:intl/intl.dart';
import 'package:thdapp/pages/project_success.dart';

class TableSubmission extends StatefulWidget {
  final Project project;
  final bool isSubmitted;

  const TableSubmission({
    Key? key,
    required this.project,
    this.isSubmitted = false,
  }) : super(key: key);

  @override
  _TableSubmissionState createState() => _TableSubmissionState();
}

class _TableSubmissionState extends State<TableSubmission> {
  final _formKey = GlobalKey<FormState>();
  final _tableNumberController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _tableNumberController.text = widget.project.tableNumber?.toString() ?? '';
  }

  @override
  void dispose() {
    _tableNumberController.dispose();
    super.dispose();
  }

  bool get canSubmit {
    final expoConfig =
        Provider.of<ExpoConfigProvider>(context, listen: false).config;
    if (expoConfig == null) return false;
    return DateTime.now().millisecondsSinceEpoch < expoConfig.expoStartTime;
  }

  String get expoStartTime {
    final expoConfig =
        Provider.of<ExpoConfigProvider>(context, listen: false).config;
    if (expoConfig == null) return '';

    final formatter =
        DateFormat('MMM d, y h:mm a'); // Example: "Mar 15, 2024 2:30 PM"
    return "${formatter.format(DateTime.fromMillisecondsSinceEpoch(expoConfig.expoStartTime))} EST";
  }

  Future<void> _submitTableNumber() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final tableNum = int.parse(_tableNumberController.text);
      final token = Provider.of<UserInfoModel>(context, listen: false).token;

      final success = await updateProjectTableNumber(
        context,
        widget.project.id,
        tableNum,
        token,
      );

      if (success) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProjectSuccess(
              project: widget.project.copyWith(
                tableNumber: tableNum.toString(),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      errorDialog(context, "Error", "Invalid table number");
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      backflag: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: GradBox(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Submit Table Number",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: canSubmit
                        ? Colors.green.withAlpha(50)
                        : Colors.orange.withAlpha(50),
                    child: Text(
                      canSubmit
                          ? "Table number submission is open until $expoStartTime. Please enter your table number to submit."
                          : "Table number submission is closed - expo has started. Please contact the organizers if you need to change your table number.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tableNumberController,
                    decoration: InputDecoration(
                      labelText: "Table Number",
                      hintText: "Enter your table number",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                      errorStyle:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a table number';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SolidButton(
                      text: _isSubmitting ? "Submitting..." : "Submit",
                      onPressed: !_isSubmitting ? _submitTableNumber : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
