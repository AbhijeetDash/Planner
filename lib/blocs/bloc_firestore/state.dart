part of 'bloc.dart';

abstract class FirestoreState {}

class InitialFirestoreState extends FirestoreState {}

class SaveTaskSuccess extends FirestoreState {}

class SaveTaskFailure extends FirestoreState {}
