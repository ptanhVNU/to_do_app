import 'package:flutter/material.dart';

import '../models/task.dart';

class EditScreen extends StatefulWidget {
  final Function updateTask;
  final Task task;
  const EditScreen({Key? key, required this.task, required this.updateTask})
      : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  // final _titleController = TextEditingController();
  // final _descriptionController = TextEditingController();

  var _editedTask = Task(id: '', title: '', description: '');

  @override
  void didChangeDependencies() {
    _editedTask = widget.task;
    super.didChangeDependencies();
  }

  void _saveForm() {
    widget.updateTask(
      _editedTask.id,
      _editedTask,
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData.fallback(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: _saveForm,
        ),
        backgroundColor: Colors.white,
        titleSpacing: 0,
        elevation: 0.15,
        title: const Text(
          'Edit',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _saveForm,
            // save task then complete finish
            icon: const Icon(Icons.save),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        margin: const EdgeInsets.fromLTRB(18, 25, 18, 25),
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                textAlign: TextAlign.left,
                initialValue: widget.task.title,
                maxLines: null,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _editedTask = Task(
                    id: _editedTask.id,
                    title: value.toString(),
                    description: _editedTask.description,
                  );
                },
              ),
              TextFormField(
                textAlign: TextAlign.left,
                initialValue: widget.task.description,
                maxLines: null,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _editedTask = Task(
                    id: _editedTask.id,
                    title: _editedTask.title,
                    description: value.toString(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
