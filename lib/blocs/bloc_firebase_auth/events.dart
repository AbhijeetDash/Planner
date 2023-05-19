part of 'bloc.dart';

abstract class AuthEvent {}

class SignUpAuthEvent extends AuthEvent {}

class CheckSignUpAuthEvent extends AuthEvent {}

class SignoutAuthEvent extends AuthEvent {}
