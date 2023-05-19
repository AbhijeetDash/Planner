import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/activities/activities.dart';
import 'package:planner/blocs/bloc_firebase_auth/bloc.dart';
import 'package:planner/blocs/bloc_firestore/bloc.dart';

import '../models/_model_task.dart';
import '_activity_create_screen.dart';

class ActivityHomeScreen extends StatefulWidget {
  final User user;
  const ActivityHomeScreen({
    super.key,
    required this.user,
  });

  @override
  State<ActivityHomeScreen> createState() => _ActivityHomeScreenState();
}

class _ActivityHomeScreenState extends State<ActivityHomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  late Size size;

  bool showDrawer = false;
  TaskModel? taskModel;
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  // We need to update the child after the drawer is visible.
  void gotoTaskForm() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ActivityCreateScreen(
          uid: widget.user.uid,
          taskModel: taskModel,
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is SignOutSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const ActivitySplashScreen()));
            });
          }

          return SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.height,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/splash_background.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    color: Colors.black.withOpacity(0.7),
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 40,
                                              backgroundImage: NetworkImage(
                                                widget.user.photoURL ?? "",
                                              ),
                                            ),
                                            const SizedBox(width: 10.0),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${widget.user.displayName}",
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "${widget.user.email}",
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                RawMaterialButton(
                                                  fillColor: Colors.deepPurple,
                                                  onPressed: () {
                                                    context
                                                        .read<AuthBloc>()
                                                        .add(
                                                            SignoutAuthEvent());
                                                  },
                                                  child: const Text(
                                                    "Sign out",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("${widget.user.uid}_tasks")
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<
                                            QuerySnapshot<Map<String, dynamic>>>
                                        snapshot) {
                                  // Check if all tasks are done

                                  if ((!snapshot.hasData ||
                                      snapshot.data!.docs.isEmpty)) {
                                    bool allTaskDone = true;
                                    for (var task
                                        in snapshot.data?.docs ?? []) {
                                      if (!task.data()['isDone']) {
                                        allTaskDone = false;
                                      }
                                    }
                                    if (allTaskDone) {
                                      return SizedBox(
                                        height: size.height * 0.5,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.add_circle_outline,
                                                size: 200,
                                                color: Colors
                                                    .deepPurpleAccent.shade100
                                                    .withOpacity(0.2),
                                              ),
                                              Text(
                                                "Create Tasks",
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors
                                                      .deepPurpleAccent.shade100
                                                      .withOpacity(0.5),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }

                                  return SizedBox(
                                    height: size.height * 0.7,
                                    child: ListView.builder(
                                      itemCount: snapshot.data?.docs.length,
                                      itemBuilder: (context, index) {
                                        TaskModel task = TaskModel.fromJson(
                                            snapshot.data!.docs[index].data());

                                        if (task.isDone) {
                                          return const SizedBox.shrink();
                                        }

                                        return Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Card(
                                            child: ListTile(
                                              onTap: () {
                                                taskModel = task;
                                                gotoTaskForm();
                                              },
                                              leading: CircleAvatar(
                                                backgroundColor: Colors.green
                                                    .withOpacity(0.4),
                                                child: IconButton(
                                                  onPressed: () {
                                                    context
                                                        .read<FirestoreBloc>()
                                                        .add(
                                                          UpdateTastEvent(
                                                            uid:
                                                                widget.user.uid,
                                                            task: task,
                                                            isComplete: true,
                                                          ),
                                                        );
                                                  },
                                                  icon: const Icon(Icons.done),
                                                ),
                                              ),
                                              title: Text(task.title),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(task.description),
                                                  const SizedBox(height: 4.0),
                                                  Text(
                                                    'Date: ${task.date.toString().split("T")[0]}',
                                                    style: const TextStyle(
                                                        fontStyle:
                                                            FontStyle.italic),
                                                  ),
                                                ],
                                              ),
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const SizedBox(width: 10.0),
                                                  CircleAvatar(
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.4),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                FirestoreBloc>()
                                                            .add(
                                                                DeleteTaskEvent(
                                                                    taskID:
                                                                        task.id,
                                                                    uid: widget
                                                                        .user
                                                                        .uid));
                                                      },
                                                      icon: const Icon(
                                                          Icons.delete),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    taskModel = null;
                    gotoTaskForm();
                  },
                )),
          );
        });
  }
}
