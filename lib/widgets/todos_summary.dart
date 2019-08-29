import 'package:flutter/material.dart';
import 'package:flutter_todo_provider/models/priority.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/helpers/ui_helper.dart';
import 'package:flutter_todo_provider/services/todo_service.dart';

class TodosSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoService>(
      builder: (context, todoService, child) => Container(
        height: 120,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Total: ${todoService.allItemsCount} task(s)',
              style: UIHelper.headerTextStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: Priority.values
                  .map((p) => Row(
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            color: UIHelper.getPriorityColor(p),
                          ),
                          UIHelper.horizontalSpaceSmall,
                          Text(
                              '${todoService.getItemsByPriority(p).length} task(s)')
                        ],
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
