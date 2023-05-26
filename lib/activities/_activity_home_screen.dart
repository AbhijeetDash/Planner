import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:planner/activities/activities.dart';
import 'package:planner/providers/_auth_state_provider.dart';
import 'package:planner/utils/_utils_string.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/_model_task.dart';
import '../services/_service_firestore.dart';
import '../widgets/_circular_percentage_indicator.dart';

class ActivityHomeScreen extends StatefulWidget {
  const ActivityHomeScreen({super.key});

  @override
  State<ActivityHomeScreen> createState() => _ActivityHomeScreenState();
}

class _ActivityHomeScreenState extends State<ActivityHomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  late Size size;
  late String uid;

  final service = locator.get<FirestoreServiceImpl>();
  bool showDrawer = false;
  TaskModel? taskModel;
  CrossFadeState crossFadeState = CrossFadeState.showFirst;

  void _completeItem(TaskModel taskModel) {
    service.updateDocumentInFirestore(
      uid,
      taskModel.copyWith(
        isDone: true,
      ),
    );
  }

  void _deleteItem(TaskModel taskModel) {
    service.deleteTask(taskModel.id, uid);
  }

  // We need to update the child after the drawer is visible.
  void gotoTaskForm(String uid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ActivityCreateScreen(
          uid: uid,
          taskModel: taskModel,
        ),
      ),
    );
  }

  void _handleSignOut(AuthStateProvider provider) {
    provider.signOut().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const ActivitySplashScreen()));
      });
    });
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthStateProvider>(
      builder: (context, provider, child) {
        if (provider.isAuthenticated) {
          uid = provider.user!.uid;
          return SafeArea(
            child: Scaffold(
              key: key,
              drawer: Drawer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              provider.user!.photoURL ?? "",
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            "${provider.user!.displayName}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${provider.user!.email}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RawMaterialButton(
                            fillColor: Colors.deepPurple,
                            onPressed: () {
                              _handleSignOut(provider);
                            },
                            child: const Text(
                              "Sign out",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/splash_background.jpg"),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: size.width * 0.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: IconButton(
                                    onPressed: () {
                                      key.currentState!.openDrawer();
                                    },
                                    icon: const Icon(
                                      Icons.menu,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    "Your Things",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 10.0),
                                  child: Text(
                                    DateTime.now().getDisplayDate(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            width: size.width * 0.5,
                            color: Colors.black.withOpacity(0.7),
                            padding: const EdgeInsets.all(12.0),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Center(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 8.0),
                                      SizedBox(
                                        width: 30.0,
                                        height: 30.0,
                                        child: CircularPercentageIndicator(
                                          percentage: 0.65,
                                          strokeWidth: 2.0,
                                        ),
                                      ),
                                      SizedBox(width: 8.0),
                                      Text("65% done", style: TextStyle(color: Colors.white),)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 5,
                            width: size.width * 0.5,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue, Colors.purple],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, top: 12.0),
                            child: Text(
                              "INBOX",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("${provider.user!.uid}_tasks")
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              // Check if all tasks are done

                              // if ((!snapshot.hasData ||
                              //     snapshot.data!.docs.isEmpty)) {
                                bool allTaskDone = true;
                                for (var task in snapshot.data?.docs ?? []) {
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
                              // }

                              return SizedBox(
                                height: size.height * 0.7,
                                child: ListView.separated(
                                  itemCount: snapshot.data?.docs.length ?? 0,
                                  itemBuilder: (context, index) {
                                    TaskModel task = TaskModel.fromJson(
                                        snapshot.data!.docs[index].data());

                                    if (task.isDone) {
                                      return const SizedBox.shrink();
                                    }

                                    return Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Dismissible(
                                          key: Key(task.id),
                                          onDismissed: (direction) {
                                            if (direction ==
                                                DismissDirection.endToStart) {
                                              _completeItem(task);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '${task.title} completed'),
                                                  duration:
                                                  const Duration(seconds: 2),
                                                ),
                                              );
                                            } else {
                                              _deleteItem(task);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '${task.title} deleted'),
                                                  duration:
                                                  const Duration(seconds: 2),
                                                ),
                                              );
                                            }


                                          },
                                          background: Container(
                                            color: Colors.red,
                                            child: const Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          secondaryBackground: Container(
                                            color: Colors.green,
                                            child: const Align(
                                              alignment: Alignment.centerRight,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 16.0),
                                                child: Icon(
                                                  Icons.done,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            onTap: () {
                                              taskModel = task;
                                              gotoTaskForm(provider.user!.uid);
                                            },
                                            leading: const CircleAvatar(
                                              radius: 30,
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundColor: Colors.white,
                                                child: Icon(Icons.task),
                                              ),
                                            ),
                                            title: Text(
                                              task.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
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
                                          ),
                                        ));
                                  },
                                  separatorBuilder: (context, index) {
                                    TaskModel task = TaskModel.fromJson(
                                        snapshot.data!.docs[index].data());
                                    if (task.isDone) {
                                      return const SizedBox.shrink();
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                      child: Divider(
                                        color: Colors.grey.withOpacity(0.5),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  taskModel = null;
                  gotoTaskForm(provider.user!.uid);
                },
              ),
            ),
          );
          // return SafeArea(
          //   child: Scaffold(
          //       resizeToAvoidBottomInset: false,
          //       body: SizedBox(
          //         width: size.width,
          //         height: size.height,
          //         child: Stack(
          //           children: [
          //             SizedBox(
          //               width: size.width,
          //               height: size.height,
          //               child: Column(
          //                 mainAxisSize: MainAxisSize.max,
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Expanded(
          //                     flex: 1,
          //                     child: Stack(
          //                       children: [
          //                         Container(
          //                           alignment: Alignment.centerLeft,
          //                           decoration: const BoxDecoration(
          //                             image: DecorationImage(
          //                               image: AssetImage(
          //                                   "assets/splash_background.jpg"),
          //                               fit: BoxFit.cover,
          //                             ),
          //                           ),
          //                         ),
          //                         Container(
          //                           width: double.maxFinite,
          //                           color: Colors.black.withOpacity(0.7),
          //                           padding: const EdgeInsets.all(20.0),
          //                           child: Column(
          //                             crossAxisAlignment:
          //                                 CrossAxisAlignment.start,
          //                             children: [
          //                               Row(
          //                                 children: [
          //                                   CircleAvatar(
          //                                     radius: 40,
          //                                     backgroundImage: NetworkImage(
          //                                       provider.user!.photoURL ?? "",
          //                                     ),
          //                                   ),
          //                                   const SizedBox(width: 10.0),
          //                                   Column(
          //                                     crossAxisAlignment:
          //                                         CrossAxisAlignment.start,
          //                                     mainAxisAlignment:
          //                                         MainAxisAlignment.start,
          //                                     children: [
          //                                       Text(
          //                                         "${provider.user!.displayName}",
          //                                         style: const TextStyle(
          //                                           fontSize: 14.0,
          //                                           color: Colors.white,
          //                                           fontWeight: FontWeight.bold,
          //                                         ),
          //                                       ),
          //                                       Text(
          //                                         "${provider.user!.email}",
          //                                         style: const TextStyle(
          //                                           fontSize: 14.0,
          //                                           color: Colors.grey,
          //                                           fontWeight: FontWeight.bold,
          //                                         ),
          //                                       ),
          //                                       RawMaterialButton(
          //                                         fillColor: Colors.deepPurple,
          //                                         onPressed: () {
          //                                           _handleSignOut(provider);
          //                                         },
          //                                         child: const Text(
          //                                           "Sign out",
          //                                           style: TextStyle(
          //                                               color: Colors.white),
          //                                         ),
          //                                       )
          //                                     ],
          //                                   )
          //                                 ],
          //                               ),
          //                             ],
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                   Expanded(
          //                     flex: 4,
          //                     child: StreamBuilder(
          //                       stream: FirebaseFirestore.instance
          //                           .collection("${provider.user!.uid}_tasks")
          //                           .snapshots(),
          //                       builder: (BuildContext context,
          //                           AsyncSnapshot<
          //                                   QuerySnapshot<Map<String, dynamic>>>
          //                               snapshot) {
          //                         // Check if all tasks are done

          //                         if ((!snapshot.hasData ||
          //                             snapshot.data!.docs.isEmpty)) {
          //                           bool allTaskDone = true;
          //                           for (var task
          //                               in snapshot.data?.docs ?? []) {
          //                             if (!task.data()['isDone']) {
          //                               allTaskDone = false;
          //                             }
          //                           }
          //                           if (allTaskDone) {
          //                             return SizedBox(
          //                               height: size.height * 0.5,
          //                               child: Center(
          //                                 child: Column(
          //                                   mainAxisAlignment:
          //                                       MainAxisAlignment.center,
          //                                   children: [
          //                                     Icon(
          //                                       Icons.add_circle_outline,
          //                                       size: 200,
          //                                       color: Colors
          //                                           .deepPurpleAccent.shade100
          //                                           .withOpacity(0.2),
          //                                     ),
          //                                     Text(
          //                                       "Create Tasks",
          //                                       style: TextStyle(
          //                                         fontSize: 32,
          //                                         fontWeight: FontWeight.bold,
          //                                         color: Colors
          //                                             .deepPurpleAccent.shade100
          //                                             .withOpacity(0.5),
          //                                       ),
          //                                     )
          //                                   ],
          //                                 ),
          //                               ),
          //                             );
          //                           }
          //                         }

          //                         return SizedBox(
          //                           height: size.height * 0.7,
          //                           child: ListView.builder(
          //                             itemCount: snapshot.data?.docs.length,
          //                             itemBuilder: (context, index) {
          //                               TaskModel task = TaskModel.fromJson(
          //                                   snapshot.data!.docs[index].data());

          //                               if (task.isDone) {
          //                                 return const SizedBox.shrink();
          //                               }

          //                               return Padding(
          //                                 padding: const EdgeInsets.all(12.0),
          //                                 child: Card(
          //                                   child: ListTile(
          //                                     onTap: () {
          //                                       taskModel = task;
          //                                       gotoTaskForm(
          //                                           provider.user!.uid);
          //                                     },
          //                                     leading: CircleAvatar(
          //                                       backgroundColor: Colors.green
          //                                           .withOpacity(0.4),
          //                                       child: IconButton(
          //                                         onPressed: () {
          //                                           _completeItem(task);
          //                                         },
          //                                         icon: const Icon(Icons.done),
          //                                       ),
          //                                     ),
          //                                     title: Text(task.title),
          //                                     subtitle: Column(
          //                                       crossAxisAlignment:
          //                                           CrossAxisAlignment.start,
          //                                       children: [
          //                                         Text(task.description),
          //                                         const SizedBox(height: 4.0),
          //                                         Text(
          //                                           'Date: ${task.date.toString().split("T")[0]}',
          //                                           style: const TextStyle(
          //                                               fontStyle:
          //                                                   FontStyle.italic),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                     trailing: Row(
          //                                       mainAxisSize: MainAxisSize.min,
          //                                       children: [
          //                                         const SizedBox(width: 10.0),
          //                                         CircleAvatar(
          //                                           backgroundColor: Colors.red
          //                                               .withOpacity(0.4),
          //                                           child: IconButton(
          //                                             onPressed: () {
          //                                               _deleteItem(task);
          //                                             },
          //                                             icon: const Icon(
          //                                                 Icons.delete),
          //                                           ),
          //                                         ),
          //                                       ],
          //                                     ),
          //                                   ),
          //                                 ),
          //                               );
          //                             },
          //                           ),
          //                         );
          //                       },
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //
          // );
        }

        return Container();
      },
    );
  }
}
