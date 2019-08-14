import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/providers/settings.dart';
import 'package:flutter_todo_provider/providers/account.dart';

class SettingsScreen extends StatelessWidget {
  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Configuration.AppName),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String choice) async {
              switch (choice) {
                case 'SignOut':
                  final accountProvider =
                      Provider.of<Account>(context, listen: false);
                  final isSignOut = await confirmSigningOut(context);

                  if (isSignOut) {
                    await accountProvider.signOut();
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'SignOut',
                  child: Text('Sign out'),
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

  Future<bool> confirmSigningOut(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm'),
        content: Text('Are you sure to signing out?'),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          )
        ],
      ),
    );
  }
}
