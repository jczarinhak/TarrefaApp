import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aula1/services/models/task_model.dart';

class TaskService {
  Future<void> saveTask(String title, String description, String priority) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    Task newTask = Task(
      title: title,
      description: description,
      isDone: false,
      priority: priority,
    );
    tasks.add(jsonEncode(newTask.toJson()));
    await prefs.setStringList('tasks', tasks);
  }

  Future<void> editTask(int index, String newTitle, String newDescription, String priority, bool isCompleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];

    if (index >= 0 && index < tasks.length) {
      Task updatedTask = Task(
        title: newTitle,
        description: newDescription,
        isDone: isCompleted,
        priority: priority,
      );
      tasks[index] = jsonEncode(updatedTask.toJson());
      await prefs.setStringList('tasks', tasks);
    }
  }

  Future<List<Task>> getTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskString = prefs.getStringList('tasks') ?? [];
    List<Task> tasks = taskString
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
    return tasks;
  }

  Future<void> deleteTask(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> tasks = prefs.getStringList('tasks') ?? [];
    
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      await prefs.setStringList('tasks', tasks);
    }
  }
}
