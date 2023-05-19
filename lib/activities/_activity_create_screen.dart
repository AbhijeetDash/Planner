import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planner/blocs/bloc_firestore/bloc.dart';
import 'package:planner/models/_model_task.dart';

class ActivityCreateScreen extends StatefulWidget {
  final String uid;
  final TaskModel? taskModel;

  const ActivityCreateScreen({
    super.key,
    required this.uid,
    required this.taskModel,
  });

  @override
  State<ActivityCreateScreen> createState() => _ActivityCreateScreenState();
}

class _ActivityCreateScreenState extends State<ActivityCreateScreen> {
  late Size size;

  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _createItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Perform the creation logic here
    String title = titleController.text;
    String description = descriptionController.text;

    // Add these details to the Firestore Bloc CreateEvent
    context.read<FirestoreBloc>().add(
          SaveTaskEvent(
            uid: widget.uid,
            title: title,
            description: description,
            dateISO: _selectedDate!.toIso8601String(),
          ),
        );

    // Reset the form after creating the item
    _formKey.currentState?.reset();

    // Hide the form after the task is created.
    Navigator.pop(context);
  }

  void _updateItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Perform the creation logic here
    String title = titleController.text;
    String description = descriptionController.text;

    // Add these details to the Firestore Bloc CreateEvent
    context.read<FirestoreBloc>().add(
          UpdateTastEvent(
            uid: widget.uid,
            task: widget.taskModel!.copyWith(
              title: title,
              description: description,
              date: _selectedDate!.toIso8601String(),
              isDone: false,
            ),
            isComplete: false,
          ),
        );

    // Reset the form after creating the item
    _formKey.currentState?.reset();

    // Hide the form after the task is created.
    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void setInitialData() {
    if (widget.taskModel == null) {
      return;
    }

    // So that it doesnt get called during build.
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _selectedDate = DateTime.tryParse(widget.taskModel!.date);
      titleController.text = widget.taskModel!.title;
      descriptionController.text = widget.taskModel!.description;
      setState(() {});
    });
  }

  @override
  void initState() {
    setInitialData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.deepPurple.shade600.withOpacity(0.7),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    width: size.width,
                    child: Row(
                      children: [
                        const Text(
                          "Create Task",
                          style: TextStyle(
                            fontSize: 28.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            // Reset the form after creating the item
                            _selectedDate = null;
                            titleController.text = "";
                            descriptionController.text = "";
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: titleController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              focusColor: Colors.white,
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepPurple, width: 2.0),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                              hintText: 'Title',
                              hintStyle: TextStyle(color: Colors.grey.shade700),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: descriptionController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              focusColor: Colors.white,
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.deepPurple, width: 2.0),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.red, width: 2.0),
                              ),
                              hintText: 'Description',
                              hintStyle: TextStyle(color: Colors.grey.shade700),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          RawMaterialButton(
                            fillColor: Colors.deepPurpleAccent,
                            onPressed: () => _selectDate(context),
                            child: SizedBox(
                              height: 55.0,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  _selectedDate != null
                                      ? '${_selectedDate!.toLocal()}'
                                          .split(' ')[0]
                                      : 'Select Date',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          RawMaterialButton(
                            fillColor: Colors.deepPurpleAccent,
                            onPressed: widget.taskModel == null
                                ? _createItem
                                : _updateItem,
                            child: SizedBox(
                              height: 55.0,
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  widget.taskModel == null
                                      ? 'Create'
                                      : 'Update',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
