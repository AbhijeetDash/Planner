import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/main.dart';
import 'package:planner/services/_service_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'states.dart';
part 'events.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
    on<SignUpAuthEvent>(_handleSignUpEvent);
    on<CheckSignUpAuthEvent>(_handleSignUpCheck);
    on<SignoutAuthEvent>(_handleSignOut);
  }

  void _handleSignUpCheck(
      CheckSignUpAuthEvent event, Emitter<AuthState> emit) async {
    // Using shared pref to maintain state.
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    bool? signedUp = sharedPreferences.getBool("signup");

    emit(CheckAuthState(signedUp ?? false));
  }

  void _handleSignUpEvent(
      SignUpAuthEvent event, Emitter<AuthState> emit) async {
    try {
      // Using shared pref to maintain state.
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // get the credential from the service.
      UserCredential? creds =
          await locator.get<AuthServiceImpl>().signInWithGoogle();

      // If null, the signup failed
      if (creds == null) {
        sharedPreferences.setBool("signup", false);
        return;
      }

      User user = creds.user!;
      sharedPreferences.setBool("signup", true);
      emit(SuccessAuthState(user));
    } catch (e) {
      rethrow;
    }
  }

  FutureOr<void> _handleSignOut(
      SignoutAuthEvent event, Emitter<AuthState> emit) async {
    try {
      // Using shared pref to maintain state.
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setBool("signup", false);
      locator.get<AuthServiceImpl>().logOut();
      emit(SignOutSuccess());
    } catch (e) {
      rethrow;
    }
  }
}
