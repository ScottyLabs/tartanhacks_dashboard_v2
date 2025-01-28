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

class TableSubmission extends StatefulWidget {
  final Project project;
  
  const TableSubmission({Key? key, required this.project}) : super(key: key);

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

  Future<void> _submitTableNumber() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final tableNum = int.parse(_tableNumberController.text);
      final token = Provider.of<UserInfoModel>(context, listen: false).token;
      
      final success = await updateProjectTableNumber(
        widget.project.id,
        tableNum,
        token,
      );

      if (success) {
        Navigator.pop(context, true);
      } else {
        errorDialog(context, "Error", "Failed to update table number");
      }
    } catch (e) {
      errorDialog(context, "Error", "Invalid table number");
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final expoConfig = Provider.of<ExpoConfigProvider>(context);
    final canSubmit = expoConfig.canSubmitTableNumber();

    return DefaultPage(
      backflag: true,
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
                  if (!canSubmit)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange.withAlpha(50),
                      child: Text(
                        "Table number submission is closed - expo has started",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _tableNumberController,
                    decoration: const InputDecoration(
                      labelText: "Table Number",
                      hintText: "Enter your table number",
                    ),
                    keyboardType: TextInputType.number,
                    enabled: canSubmit,
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
                      onPressed: canSubmit && !_isSubmitting ? _submitTableNumber : null,
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