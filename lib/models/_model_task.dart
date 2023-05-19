import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part '_model_task.g.dart';

@JsonSerializable()
class TaskModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String date;
  final bool isDone;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isDone,
  });

  factory TaskModel.fromJson(Map<String, dynamic> data) =>
      _$TaskModelFromJson(data);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
    bool? isDone,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
    );
  }

  @override
  List<Object?> get props => [id, title, description, date, isDone];
}
