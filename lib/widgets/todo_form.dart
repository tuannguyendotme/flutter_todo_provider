import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/providers/todos.dart';
import 'package:flutter_todo_provider/ui_helper.dart';
import 'package:flutter_todo_provider/widgets/priority_form_field.dart';
import 'package:flutter_todo_provider/widgets/toggle_form_field.dart';
import 'package:provider/provider.dart';

class TodoForm extends StatefulWidget {
  final Todo todo;

  TodoForm(this.todo);

  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final Map<String, dynamic> _formData = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Todo todo;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    todo = widget.todo;

    _formData['title'] = todo.title;
    _formData['content'] = todo.content;
    _formData['priority'] = todo.priority;
    _formData['isDone'] = todo.isDone;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _buildTitleField(todo),
          _buildContentField(todo),
          UIHelper.verticalSpaceSmall,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ToggleFormField(
                initialValue: todo.isDone,
                onSaved: (value) {
                  _formData['isDone'] = value;
                },
              ),
              PriorityFormField(
                initialValue: todo.priority,
                onSaved: (value) {
                  _formData['priority'] = value;
                },
              )
            ],
          ),
          UIHelper.verticalSpaceMedium,
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildButtonRow(),
        ],
      ),
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: RaisedButton.icon(
            icon: Icon(Icons.cancel),
            label: Text('Cancel'),
            elevation: 0,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          width: 120,
          height: 56,
        ),
        UIHelper.horizontalSpaceMedium,
        Container(
          child: RaisedButton.icon(
            icon: Icon(Icons.save),
            label: Text('Save'),
            elevation: 0,
            onPressed: _save,
          ),
          width: 120,
          height: 56,
        ),
      ],
    );
  }

  Widget _buildTitleField(Todo todo) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Title'),
      initialValue: todo.title,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter todo\'s title';
        }

        return null;
      },
      onSaved: (value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildContentField(Todo todo) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Content'),
      initialValue: todo.content,
      maxLines: 5,
      onSaved: (value) {
        _formData['content'] = value;
      },
    );
  }

  Future _save() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    final newTodo = todo.copyWith(
      title: _formData['title'],
      content: _formData['content'],
      priority: _formData['priority'],
      isDone: _formData['isDone'],
    );

    setState(() {
      _isLoading = true;
    });

    await Provider.of<Todos>(context, listen: false).addTodo(newTodo);

    setState(() {
      _isLoading = false;
    });

    Navigator.pop(context);
  }
}
