import '../models/_model_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirestoreService {
  // Save the task to the database.
  Future<void> saveDocumentToFirestore(TaskModel task, String uid);

  // Update the task in the database
  Future<void> updateDocumentInFirestore(String uid, TaskModel task);

  // Delete the task from the database.
  Future<void> deleteTask(String taskID, String uid);
}

class FirestoreServiceImpl extends FirestoreService {
  @override
  void getTaskList() {}

  @override
  Future<void> saveDocumentToFirestore(TaskModel task, String uid) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('${uid}_tasks');
      await collectionRef.doc(task.id).set(task.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateDocumentInFirestore(String uid, TaskModel task) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('${uid}_tasks');
      await collectionRef.doc(task.id).update(task.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String taskID, String uid) async {
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('${uid}_tasks');
      await collectionRef.doc(taskID).delete();
    } catch (e) {
      rethrow;
    }
  }
}
