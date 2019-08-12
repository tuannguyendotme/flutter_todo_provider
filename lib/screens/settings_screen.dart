import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/providers/settings.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Configuration.AppName),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String choice) {
              switch (choice) {
                case 'LogOut':
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'LogOut',
                  child: Text('Log out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Consumer<Settings>(
            builder: (context, settings, child) => SwitchListTile(
              activeColor: Theme.of(context).accentColor,
              value: settings.useDarkTheme,
              onChanged: (value) {
                settings.toggleTheme();
              },
              title: Text('Use dark theme'),
            ),
          )
        ],
      ),
    );
  }
}
