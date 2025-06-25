// lib/models/task.dart
import 'package:uuid/uuid.dart';

class Task {
  final String id;
  final String projectId;
  final String name;

  Task({String? id, required this.projectId, required this.name})
    : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'name': name,
  };
  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(id: json['id'], projectId: json['projectId'], name: json['name']);
}
