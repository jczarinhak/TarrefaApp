import 'package:aula1/services/models/task_model.dart';
import 'package:aula1/services/task_service.dart';
import 'package:aula1/views/form_tasks.dart';
import 'package:flutter/material.dart';

class ListViewTask extends StatefulWidget {
  const ListViewTask({super.key});

  @override
  State<ListViewTask> createState() => _ListViewTaskState();
}

class _ListViewTaskState extends State<ListViewTask> {
  TaskService taskService = TaskService();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    getAllTasks();
  }

  Future<void> getAllTasks() async {
    tasks = await taskService.getTasks();
    setState(() {});
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.red;
      case 'Média':
        return Colors.orange;
      case 'Baixa':
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _buildTaskCard(index);
        },
      ),
    );
  }

  Widget _buildTaskCard(int index) {
    final task = tasks[index];
    bool localIsDone = task.isDone;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Título da tarefa
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue,
                      decoration: localIsDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                // Checkbox para marcar como concluído
                Checkbox(
                  value: localIsDone,
                  onChanged: (value) async {
                    if (value != null) {
                      setState(() {
                        localIsDone = value;
                      });

                      await taskService.editTask(
                        index,
                        task.title,
                        task.description,
                        task.priority,
                        value,
                      );

                      setState(() {
                        tasks[index].isDone = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16), // Espaçamento maior
            // Descrição da tarefa
            Center(
              child: Text(
                task.description,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16), // Mais espaçamento abaixo da descrição
            // Prioridade da tarefa bem mais embaixo
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Prioridade: ${task.priority}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getPriorityColor(task.priority),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: localIsDone ? Colors.grey : Colors.red,
                  ),
                  onPressed: localIsDone
                      ? null
                      : () async {
                          await taskService.deleteTask(index);
                          getAllTasks();
                        },
                ),
                const SizedBox(width: 8),
                if (!localIsDone)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormTasks(
                            task: tasks[index],
                            index: index,
                          ),
                        ),
                      ).then((value) => getAllTasks());
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
