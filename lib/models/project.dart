// lib/models/project.dart
import 'package:uuid/uuid.dart';

class Project {
  final String id;
  final String name;

  Project({String? id, required this.name}) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Project.fromJson(Map<String, dynamic> json) =>
      Project(id: json['id'], name: json['name']);
}
