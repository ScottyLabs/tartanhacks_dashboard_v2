import 'package:flutter/material.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/models/project.dart';

class ProjectSuccess extends StatelessWidget {
  final Project project;

  const ProjectSuccess({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      backflag: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: GradBox(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  "Project Successfully Submitted!",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  "Table Number: ${project.tableNumber}",
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  "Please attend to your table when the expo begins.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
