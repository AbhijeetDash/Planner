import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/blocs/bloc_firebase_auth/bloc.dart';

import '_activity_home_screen.dart';

class ActivitySplashScreen extends StatefulWidget {
  const ActivitySplashScreen({super.key});

  @override
  State<ActivitySplashScreen> createState() => _ActivitySplashScreenState();
}

class _ActivitySplashScreenState extends State<ActivitySplashScreen> {
  late Size size;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    context.read<AuthBloc>().add(CheckSignUpAuthEvent());
    super.didChangeDependencies();
  }

  void initiateGoogleSignUp() {
    context.read<AuthBloc>().add(SignUpAuthEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is CheckAuthState) {
          if (state.shouldLogin) {
            // We should keep showing the loading and login user.
            initiateGoogleSignUp();
          }
        }
      },
      builder: (context, state) {
        if (state is SuccessAuthState) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ActivityHomeScreen(user: state.user)));
          });
        }

        bool shouldShowButton = false;
        if (state is CheckAuthState) {
          if (!state.shouldLogin) {
            shouldShowButton = true;
          }
        }

        return SafeArea(
          child: Scaffold(
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    width: size.width,
                    height: size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/splash_background.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: size.width,
                      height: size.height,
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.7)),
                    ),
                  ),
                  SizedBox(
                    width: size.width,
                    height: size.height,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Planner",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 46,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Your daily schedule buddy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        shouldShowButton
                            ? RawMaterialButton(
                                fillColor: Colors.deepPurple.shade100,
                                shape: const StadiumBorder(),
                                onPressed: () => initiateGoogleSignUp(),
                                child: Container(
                                  width: size.width * 0.5,
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/google.png",
                                        width: 35,
                                        height: 35,
                                      ),
                                      const SizedBox(width: 10.0),
                                      const Text(
                                        "SIGN UP",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const CircularProgressIndicator(),
                        const SizedBox(height: 50.0),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
