import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:planner/services/_service_auth.dart';
import 'package:planner/services/_service_firestore.dart';

import 'activities/activities.dart';
import 'firebase_options.dart';

final locator = GetIt.asNewInstance();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Firebase App
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register all the services in locator
  locator.registerSingleton<AuthServiceImpl>(AuthServiceImpl());
  locator.registerSingleton<FirestoreServiceImpl>(FirestoreServiceImpl());

  runApp(const ActivityInternal());
}
