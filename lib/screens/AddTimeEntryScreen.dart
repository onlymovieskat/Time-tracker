import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  const AddTimeEntryScreen({super.key});
  @override
  State<AddTimeEntryScreen> createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _form = GlobalKey<FormState>();
  String? _projId, _taskId;
  DateTime _date = DateTime.now();
  int _hours = 1;
  final _notesCtrl = TextEditingController();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _save() {
    if (_form.currentState!.validate()) {
      final entry = TimeEntry(
        projectId: _projId!,
        taskId: _taskId!,
        totalMinutes: _hours * 60,
        date: _date,
        notes: _notesCtrl.text,
      );
      context.read<TimeEntryProvider>().add(entry);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final projects = context.watch<ProjectProvider>().projects;
    final tasks = context
        .watch<TaskProvider>()
        .tasks
        .where((t) => t.projectId == _projId)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Time Entry'),
        backgroundColor: const Color(0xFF419688),
        leading: BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              // Project
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Project'),
                items: projects
                    .map(
                      (p) => DropdownMenuItem(value: p.id, child: Text(p.name)),
                    )
                    .toList(),
                onChanged: (v) => setState(() {
                  _projId = v;
                  _taskId = null;
                }),
                validator: (v) => v == null ? 'Select a project' : null,
              ),

              const SizedBox(height: 12),
              // Task
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Task'),
                items: tasks
                    .map(
                      (t) => DropdownMenuItem(value: t.id, child: Text(t.name)),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _taskId = v),
                validator: (v) => v == null ? 'Select a task' : null,
              ),

              const SizedBox(height: 16),
              // Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Date: ${DateFormat.yMMMd().format(_date)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),

              // Total Time
              TextFormField(
                initialValue: '1',
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Total Time (in hours)',
                ),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return (n == null || n < 1) ? 'Enter valid hours' : null;
                },
                onChanged: (v) => _hours = int.tryParse(v) ?? 1,
              ),

              const SizedBox(height: 12),
              // Notes
              TextFormField(
                controller: _notesCtrl,
                decoration: const InputDecoration(labelText: 'Note'),
                maxLines: 3,
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save Time Entry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
