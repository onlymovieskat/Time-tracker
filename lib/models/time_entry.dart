// lib/models/time_entry.dart
import 'package:uuid/uuid.dart';

class TimeEntry {
  final String id;
  final String projectId;
  final String taskId;
  final int totalMinutes;
  final DateTime date;
  final String notes;

  TimeEntry({
    String? id,
    required this.projectId,
    required this.taskId,
    required this.totalMinutes,
    required this.date,
    required this.notes,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'taskId': taskId,
    'totalMinutes': totalMinutes,
    'date': date.toIso8601String(),
    'notes': notes,
  };

  factory TimeEntry.fromJson(Map<String, dynamic> json) => TimeEntry(
    id: json['id'],
    projectId: json['projectId'],
    taskId: json['taskId'],
    totalMinutes: json['totalMinutes'],
    date: DateTime.parse(json['date']),
    notes: json['notes'],
  );
}
