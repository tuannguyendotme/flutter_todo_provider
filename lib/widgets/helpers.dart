import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/models/priority.dart';

Color getPriorityColor(Priority priority) {
  switch (priority) {
    case Priority.High:
      return Colors.redAccent;

    case Priority.Medium:
      return Colors.amber;

    default:
      return Colors.lightGreen;
  }
}
