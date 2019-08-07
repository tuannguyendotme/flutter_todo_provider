import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/models/priority.dart';
import 'package:flutter_todo_provider/ui_helper.dart';

class PriorityFormField extends FormField<Priority> {
  PriorityFormField({
    @required FormFieldSetter<Priority> onSaved,
    Priority initialValue = Priority.Low,
  }) : super(
          onSaved: onSaved,
          initialValue: initialValue,
          builder: (FormFieldState<Priority> state) {
            return Row(
              children: Priority.values
                  .map((priority) => Container(
                        height: 60.0,
                        child: FlatButton(
                          color: UIHelper.getPriorityColor(priority),
                          child: state.value == priority
                              ? Icon(Icons.check)
                              : null,
                          onPressed: () {
                            state.didChange(priority);
                          },
                        ),
                      ))
                  .toList(),
            );
          },
        );
}
