import 'package:aula1/services/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:aula1/services/task_service.dart';

class FormTasks extends StatefulWidget {
  final Task? task;
  final int? index;

  const FormTasks({super.key, this.task, this.index});

  @override
  State<FormTasks> createState() => _FormTasksState();
}

class _FormTasksState extends State<FormTasks> {
  final _formKey = GlobalKey<FormState>();
  final TaskService taskService = TaskService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _priority = 'Baixa'; // Prioridade padrão

  @override
  void initState() {
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _priority = widget.task!.priority; // Inicializando com a prioridade existente
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final appBarTitle = isEditing ? 'Editar tarefa' : 'Formulário';
    final buttonText = isEditing ? 'Alterar Tarefa' : 'Salvar Tarefa';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Alinha os elementos à esquerda
            children: [
              TextFormField(
                controller: _titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Título não preenchido';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: const Text('Título'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  label: const Text('Descrição da Tarefa'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Prioridade:', 
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft, // Alinha a seção de prioridade no canto inferior esquerdo
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinha os itens à esquerda
                  children: [
                    RadioListTile<String>(
                      title: const Text('Baixa'),
                      value: 'Baixa',
                      groupValue: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value ?? 'Baixa';
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Média'),
                      value: 'Média',
                      groupValue: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value ?? 'Baixa';
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Alta'),
                      value: 'Alta',
                      groupValue: _priority,
                      onChanged: (value) {
                        setState(() {
                          _priority = value ?? 'Baixa';
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Espaço antes do botão
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String title = _titleController.text;
                      String description = _descriptionController.text;

                      if (widget.task != null && widget.index != null) {
                        await taskService.editTask(
                          widget.index!, 
                          title, 
                          description, 
                          _priority, 
                          widget.task!.isDone 
                        );
                      } else {
                        await taskService.saveTask(
                          title, 
                          description, 
                          _priority
                        );
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isEditing ? 'Tarefa alterada com sucesso!' : 'Tarefa salva com sucesso!')),
                      );

                      _titleController.clear();
                      _descriptionController.clear();

                      Navigator.pop(context);
                    }
                  },
                  child: Text(buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
