part of 'bloc.dart';

abstract class FirestoreEvent {}

class SaveTaskEvent extends FirestoreEvent {
  final String uid;
  final String title;
  final String description;
  final String dateISO;

  SaveTaskEvent({
    required this.uid,
    required this.title,
    required this.description,
    required this.dateISO,
  });
}

class UpdateTastEvent extends FirestoreEvent {
  final String uid;
  final TaskModel task;
  final bool isComplete;

  UpdateTastEvent({
    required this.uid,
    required this.task,
    required this.isComplete,
  });
}

class DeleteTaskEvent extends FirestoreEvent {
  final String taskID;
  final String uid;

  DeleteTaskEvent({
    required this.taskID,
    required this.uid,
  });
}
