// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'shared_helpers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Scheduler',
      home: ScheduleScreen(),
    );
  }
}

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class Task {
  final int id;
  final DateTime date;
  String description;

  Task({required this.id, required this.date, this.description = ''});
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Task> tasks = [];
  TextEditingController _dateController = TextEditingController();
  TextEditingController _taskController = TextEditingController();
  TextEditingController _editTaskController = TextEditingController();
  int _nextId = 1;
  int _generateNextId() {
    return _nextId++;
  }

  void _editTask(Task task, String newDescription) {
    setState(() {
      task.description = newDescription;
    });
  }

  @override
  void initState() {
    helper.getValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Scheduler'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Date (yyyy-mm-dd)',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a date';
                  }
                  try {
                    DateTime.parse(value!);
                  } catch (e) {
                    return 'Please enter a valid date format';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _taskController,
                decoration: InputDecoration(
                  labelText: 'Task Description',
                ),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a task description';
                  }
                  return null;
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var newTask = Task(
                      id: _generateNextId(),
                      date: DateTime.parse(_dateController.text),
                      description: _taskController.text);
                  setState(() {
                    tasks.add(newTask);
                  });
                  helper.setValues(
                      '${_dateController.text}, ${_taskController.text}');
                }
              },
              child: Text('Add Task'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  var task = tasks[index];
                  return ListTile(
                    title: Text(DateFormat.yMMMMd().format(task.date)),
                    subtitle: Text(task.description),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          tasks.removeAt(index);
                        });
                      },
                    ),
                    onTap: () async {
                      final editedDescription = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Edit Task'),
                            content: TextFormField(
                              //initialValue: task.description,
                              controller: _editTaskController,
                              decoration: InputDecoration(
                                labelText: 'Task Description',
                              ),
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Please enter a task description';
                                }
                                return null;
                              },
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('Save'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(_taskController.text);
                                  if (_editTaskController.text.isNotEmpty) {
                                    setState(() {
                                      task.description =
                                          _editTaskController.text;
                                    });
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
