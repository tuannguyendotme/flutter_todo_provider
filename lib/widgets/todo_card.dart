import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/models/priority.dart';
import 'package:flutter_todo_provider/ui_helper.dart';

class TodoCard extends StatelessWidget {
  final String id;
  final String title;
  final Priority priority;
  final bool isDone;

  const TodoCard({
    Key key,
    @required this.id,
    @required this.title,
    @required this.priority,
    @required this.isDone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              color: UIHelper.getPriorityColor(priority),
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(4.0),
                bottomLeft: const Radius.circular(4.0),
              ),
            ),
            width: 40.0,
            height: 80.0,
            child: isDone
                ? IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {},
                  )
                : IconButton(
                    icon: Icon(Icons.check_box_outline_blank),
                    onPressed: () {},
                  ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                title,
                style: TextStyle(
                    fontSize: 24.0,
                    decoration: isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
