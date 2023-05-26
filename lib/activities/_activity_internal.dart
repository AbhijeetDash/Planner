import 'package:flutter/material.dart';
import 'package:planner/activities/activities.dart';
import 'package:planner/providers/_auth_state_provider.dart';
import 'package:provider/provider.dart';

class ActivityInternal extends StatelessWidget {
  const ActivityInternal({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthStateProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const ActivitySplashScreen(),
      ),
    );
    // return MultiBlocProvider(
    //   providers: [
    //     // BlocProvider(create: (_) => AuthBloc()),
    //     // BlocProvider(create: (_) => FirestoreBloc()),
    //   ],
    //   child: Builder(builder: (context) {

    //   }),
    // );
  }
}
