import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:planner/main.dart';
import 'package:planner/services/_service_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthStateProvider extends ChangeNotifier {
  final authService = locator.get<AuthServiceImpl>();
  late User? user;
  bool isAuthenticated = false;

  Future<void> getAuthenticationState() async {
    // Using shared pref to maintain state.
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    bool? signedUp = sharedPreferences.getBool("signup");
    // If the user is signed up this is true.
    isAuthenticated = signedUp ?? false;
  }

  Future<void> signUp() async {
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

    user = creds.user!;
    isAuthenticated = true;
    sharedPreferences.setBool("signup", true);
  }

  Future<void> signOut() async {
    // Using shared pref to maintain state.
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    await locator.get<AuthServiceImpl>().logOut();
    isAuthenticated = false;
    user = null;
    sharedPreferences.setBool("signup", false);
  }
}
