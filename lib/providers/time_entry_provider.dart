// lib/providers/project_provider.dart
import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/models/time_entry.dart';
import '../models/project.dart';

class ProjectProvider with ChangeNotifier {
  final LocalStorage _storage = LocalStorage('projects.json');
  List<Project> _projects = [];
  List<Project> get projects => _projects;

  Future<void> load() async {
    await _storage.ready;
    final raw = _storage.getItem('projects') as List<dynamic>? ?? [];
    _projects = raw.map((j) => Project.fromJson(j)).toList();
    notifyListeners();
  }

  Future<void> add(Project p) async {
    _projects.add(p);
    await _storage.setItem(
      'projects',
      _projects.map((e) => e.toJson()).toList(),
    );
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _projects.removeWhere((p) => p.id == id);
    await _storage.setItem(
      'projects',
      _projects.map((e) => e.toJson()).toList(),
    );
    notifyListeners();
  }
}

// lib/providers/task_provider.dart

class TaskProvider with ChangeNotifier {
  final LocalStorage _storage = LocalStorage('tasks.json');
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  Future<void> load() async {
    await _storage.ready;
    final raw = _storage.getItem('tasks') as List<dynamic>? ?? [];
    _tasks = raw.map((j) => Task.fromJson(j)).toList();
    notifyListeners();
  }

  Future<void> add(Task t) async {
    _tasks.add(t);
    await _storage.setItem('tasks', _tasks.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _storage.setItem('tasks', _tasks.map((e) => e.toJson()).toList());
    notifyListeners();
  }
}

// lib/providers/time_entry_provider.dart

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage _storage = LocalStorage('time_entries.json');
  List<TimeEntry> _entries = [];
  List<TimeEntry> get entries => _entries;

  Future<void> load() async {
    await _storage.ready;
    final raw = _storage.getItem('entries') as List<dynamic>? ?? [];
    _entries = raw.map((j) => TimeEntry.fromJson(j)).toList();
    notifyListeners();
  }

  Future<void> add(TimeEntry e) async {
    _entries.add(e);
    await _storage.setItem('entries', _entries.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> remove(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _storage.setItem('entries', _entries.map((e) => e.toJson()).toList());
    notifyListeners();
  }
}
