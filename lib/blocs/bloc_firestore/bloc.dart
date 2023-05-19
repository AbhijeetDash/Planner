import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/main.dart';
import 'package:planner/models/_model_task.dart';
import 'package:planner/services/_service_firestore.dart';

import '../../utils/_utils_string.dart';

part 'event.dart';
part 'state.dart';

class FirestoreBloc extends Bloc<FirestoreEvent, FirestoreState> {
  FirestoreBloc() : super(InitialFirestoreState()) {
    on<SaveTaskEvent>(_handleSaveTask);
    on<UpdateTastEvent>(_handleUpdateTask);
    on<DeleteTaskEvent>(_handleDeleteTask);
  }

  FutureOr<void> _handleSaveTask(
      SaveTaskEvent event, Emitter<FirestoreState> emit) {
    try {
      String id = generateRandomString();
      TaskModel task = TaskModel(
          id: id,
          title: event.title,
          description: event.description,
          date: event.dateISO,
          isDone: false);

      locator
          .get<FirestoreServiceImpl>()
          .saveDocumentToFirestore(task, event.uid);
      emit(SaveTaskSuccess());
    } catch (e) {
      emit(SaveTaskFailure());
    }
  }

  FutureOr<void> _handleUpdateTask(
      UpdateTastEvent event, Emitter<FirestoreState> emit) {
    try {
      if (event.isComplete) {
        TaskModel task = event.task.copyWith(isDone: true);
        locator
            .get<FirestoreServiceImpl>()
            .updateDocumentInFirestore(event.uid, task);
        return null;
      }

      locator
          .get<FirestoreServiceImpl>()
          .updateDocumentInFirestore(event.uid, event.task);
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> _handleDeleteTask(
      DeleteTaskEvent event, Emitter<FirestoreState> emit) {
    try {
      locator.get<FirestoreServiceImpl>().deleteTask(event.taskID, event.uid);
    } catch (e) {
      rethrow;
    }
  }
}
