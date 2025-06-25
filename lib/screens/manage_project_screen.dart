import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/providers/time_entry_provider.dart';
import '../models/project.dart';

class ManageProjectsScreen extends StatelessWidget {
  const ManageProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Projects'),
        backgroundColor: Colors.purple,
        leading: BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Project'),
              onPressed: () => _showAddDialog(context),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: projects.length,
                itemBuilder: (_, i) {
                  final p = projects[i];
                  return ListTile(
                    title: Text(p.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () =>
                          context.read<ProjectProvider>().remove(p.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddDialog(BuildContext c) {
    final ctrl = TextEditingController();
    showDialog(
      context: c,
      builder: (_) => AlertDialog(
        title: const Text('Add Project'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Project Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) {
                c.read<ProjectProvider>().add(Project(name: ctrl.text));
              }
              Navigator.pop(c);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
