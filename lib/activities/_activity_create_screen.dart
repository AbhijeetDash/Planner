import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:planner/main.dart';
import 'package:planner/models/_model_task.dart';
import 'package:planner/providers/_auth_state_provider.dart';
import 'package:planner/services/_service_firestore.dart';
import 'package:provider/provider.dart';

import '../utils/_utils_string.dart';

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
  late String uid;

  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _createItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final service = locator.get<FirestoreServiceImpl>();

    // Perform the creation logic here
    String title = titleController.text;
    String description = descriptionController.text;
    String id = generateRandomString();

    final task = TaskModel(
      id: id,
      title: title,
      description: description,
      date: _selectedDate!.toIso8601String(),
      isDone: false,
    );

    service.saveDocumentToFirestore(task, uid);

    // Reset the form after creating the item
    _formKey.currentState?.reset();

    // Hide the form after the task is created.
    Navigator.pop(context);
  }

  void _updateItem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final service = locator.get<FirestoreServiceImpl>();

    // Perform the creation logic here
    String title = titleController.text;
    String description = descriptionController.text;

    service.updateDocumentInFirestore(
      uid,
      widget.taskModel!.copyWith(
        title: title,
        description: description,
        date: _selectedDate!.toIso8601String(),
        isDone: false,
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
    uid = context.read<AuthStateProvider>().user!.uid;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: size.width,
        height: size.height,
        color: const Color.fromRGBO(88, 86, 140, 1.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Reset the form after creating the item
                        _selectedDate = null;
                        titleController.text = "";
                        descriptionController.text = "";
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    const Text(
                      "Add a new thing",
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.tune,
                        color: Colors.lightBlueAccent,
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
                      const Center(
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 45.0,
                            backgroundColor: Color.fromRGBO(88, 86, 140, 1.0),
                            child: Icon(
                              Icons.task,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      TextFormField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                        cursorColor: Colors.grey.shade500,
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
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                        ),
                        cursorColor: Colors.grey.shade500,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      RawMaterialButton(
                        onPressed: () => _selectDate(context),
                        child: SizedBox(
                          height: 55.0,
                          width: double.infinity,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade600,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.toLocal()}'.split(' ')[0]
                                  : 'Select Date',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      RawMaterialButton(
                        fillColor: Colors.blue,
                        onPressed: widget.taskModel == null
                            ? _createItem
                            : _updateItem,
                        child: SizedBox(
                          height: 55.0,
                          width: double.infinity,
                          child: Center(
                            child: Text(
                              widget.taskModel == null ? 'Create' : 'Update',
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
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
