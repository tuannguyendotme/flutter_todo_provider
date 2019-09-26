import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/helpers/ui_helper.dart';
import 'package:flutter_todo_provider/models/priority.dart';
import 'package:flutter_todo_provider/services/todo_service.dart';

class TodosSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoService>(
      builder: (context, todoService, child) {
        final highCount = todoService.getItemCountByPriority(Priority.High);
        final mediumCount = todoService.getItemCountByPriority(Priority.Medium);
        final lowCount = todoService.getItemCountByPriority(Priority.Low);

        Map<String, double> dataMap = new Map();
        dataMap.putIfAbsent("High", () => highCount);
        dataMap.putIfAbsent("Medium", () => mediumCount);
        dataMap.putIfAbsent("Low", () => lowCount);

        return Container(
          height: 180,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: UIHelper.headerTextStyle,
                    ),
                    Text(
                      '${todoService.allItemsCount}',
                      style: UIHelper.headerTextStyle,
                    ),
                    Text(
                      'task(s)',
                      style: UIHelper.headerTextStyle,
                    ),
                  ],
                ),
              ),
              PieChart(
                dataMap: dataMap,
                colorList: [Colors.redAccent, Colors.amber, Colors.lightGreen],
                chartRadius: 140,
                legendFontColor: Theme.of(context).textTheme.title.color,
                chartValuesColor: Theme.of(context).textTheme.title.color,
              ),
            ],
          ),
        );
      },
    );
  }
}
