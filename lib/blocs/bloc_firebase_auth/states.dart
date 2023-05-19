part of 'bloc.dart';

abstract class AuthState {}

class InitialAuthState extends AuthState {}

class SuccessAuthState extends AuthState {
  final User user;
  SuccessAuthState(this.user);
}

class CheckAuthState extends AuthState {
  final bool shouldLogin;
  CheckAuthState(this.shouldLogin);
}

class SignOutSuccess extends AuthState {}
