import 'package:flutter_todo_provider/models/priority.dart';

class Todo {
  final String id;
  final String title;
  final String content;
  final Priority priority;
  final bool isDone;
  final String userId;

  Todo({
    this.id,
    this.title,
    this.content,
    this.priority,
    this.isDone,
    this.userId,
  });

  Todo.fromJson(String id, Map<String, dynamic> json)
      : id = id,
        title = json['title'],
        content = json['content'],
        priority = toPriority(json['priority']),
        isDone = json['isDone'],
        userId = json['userId'];

  Todo.initial(String userId)
      : id = null,
        title = '',
        content = '',
        priority = Priority.Low,
        isDone = false,
        this.userId = userId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'priority': priority.toString(),
        'isDone': isDone,
        'userId': userId,
      };

  Todo copyWith({
    String id,
    String title,
    String content,
    Priority priority,
    bool isDone,
    String userId,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      priority: priority ?? this.priority,
      isDone: isDone ?? this.isDone,
      userId: userId ?? this.userId,
    );
  }
}
