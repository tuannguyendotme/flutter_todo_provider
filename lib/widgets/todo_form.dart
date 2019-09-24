import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/http_exception.dart';
import 'package:flutter_todo_provider/helpers/ui_helper.dart';
import 'package:flutter_todo_provider/models/todo.dart';
import 'package:flutter_todo_provider/services/todo_service.dart';
import 'package:flutter_todo_provider/widgets/priority_form_field.dart';
import 'package:flutter_todo_provider/widgets/toggle_form_field.dart';

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
  String _errorMessage = '';

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
          if (_errorMessage != '') _buildErrorPlaceHolder(),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _buildButtonRow(),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceHolder() {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            _errorMessage,
            style: TextStyle(
              color: Theme.of(context).errorColor,
            ),
          ),
        ),
        UIHelper.verticalSpaceMedium
      ],
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton.icon(
          icon: Icon(Icons.cancel),
          label: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        UIHelper.horizontalSpaceMedium,
        RaisedButton.icon(
          icon: Icon(Icons.save),
          label: Text('Save'),
          onPressed: _save,
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
      _errorMessage = '';
    });

    final todoService = Provider.of<TodoService>(context, listen: false);

    try {
      if (todo.id == null) {
        await todoService.addTodo(newTodo);
      } else {
        await todoService.updateTodo(newTodo);
      }
    } on HttpException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    }

    setState(() {
      _isLoading = false;
    });

    if (_errorMessage == '') {
      Navigator.pop(context);
    }
  }
}
