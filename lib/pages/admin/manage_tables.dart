import 'package:flutter/material.dart';
import 'package:thdapp/components/DefaultPage.dart';
import 'package:thdapp/components/buttons/GradBox.dart';
import 'package:thdapp/components/ErrorDialog.dart';
import 'package:thdapp/api.dart';
import 'package:thdapp/models/project.dart';
import 'package:thdapp/models/config.dart';
import 'package:provider/provider.dart';
import 'package:thdapp/providers/user_info_provider.dart';

class ManageTablesPage extends StatefulWidget {
  @override
  _ManageTablesPageState createState() => _ManageTablesPageState();
}

class _ManageTablesPageState extends State<ManageTablesPage> {
  List<Project> projects = [];
  bool isLoading = true;
  ExpoConfig? expoConfig;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final token = Provider.of<UserInfoModel>(context, listen: false).token;
      projects = await getAllProjects(token);
      expoConfig = await getExpoConfig(token);
    } catch (e) {
      errorDialog(context, "Error", "Failed to load data");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _buildExpoStatus() {
    if (expoConfig == null) return const SizedBox.shrink();

    final now = DateTime.now();
    final isBeforeExpo = now.isBefore(expoConfig!.expoStartTime);
    
    return Container(
      padding: const EdgeInsets.all(8),
      color: isBeforeExpo ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
      child: Text(
        isBeforeExpo 
          ? "Participants can still submit table numbers"
          : "Expo has started - Only admin can modify tables",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Future<void> _updateTableNumber(Project project, String newTableNumber) async {
    try {
      int? tableNum = int.tryParse(newTableNumber);
      if (tableNum != null) {
        // TODO: Add API call to update table number
        // await updateProjectTableNumber(project.id, tableNum);
        await _loadData(); // Refresh the list
      }
    } catch (e) {
      errorDialog(context, "Error", "Failed to update table number");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultPage(
      backflag: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: GradBox(
          child: Column(
            children: [
              Text(
                "Manage Project Tables",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildExpoStatus(),
              const SizedBox(height: 16),
              if (isLoading)
                const CircularProgressIndicator()
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return ListTile(
                        title: Text(project.name),
                        subtitle: Text("Current Table: ${project.tableNumber ?? 'Not assigned'}"),
                        trailing: SizedBox(
                          width: 100,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Table #",
                            ),
                            onSubmitted: (value) => _updateTableNumber(project, value),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
} 