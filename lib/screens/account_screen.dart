import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:flutter_todo_provider/.env.dart';
import 'package:flutter_todo_provider/http_exception.dart';
import 'package:flutter_todo_provider/helpers/ui_helper.dart';
import 'package:flutter_todo_provider/services/account_service.dart';

enum _FormMode {
  SignIn,
  SignUp,
}

class AccountScreen extends StatefulWidget {
  static const String routeName = '/account';

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };
  final TextEditingController _passwordController = TextEditingController();
  _FormMode _formMode = _FormMode.SignIn;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Configuration.AppName),
      ),
      body: Container(
        padding: UIHelper.padding,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 320,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildEmailField(),
                    _buildPasswordField(),
                    if (_formMode == _FormMode.SignUp)
                      _buildConfirmPasswordField(),
                    UIHelper.verticalSpaceMedium,
                    if (_errorMessage != '') _buildErrorPlaceHolder(),
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Column(
                            children: <Widget>[
                              _buildFinishButton(),
                              UIHelper.verticalSpaceSmall,
                              _buildSwitchModeButton()
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
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

  Widget _buildSwitchModeButton() {
    return FlatButton(
      child: Text(
        _formMode == _FormMode.SignIn
            ? 'Switch to sign up'
            : 'Switch to sign in',
      ),
      onPressed: () {
        final newFormMode =
            _formMode == _FormMode.SignIn ? _FormMode.SignUp : _FormMode.SignIn;

        setState(() {
          _formMode = newFormMode;
        });
      },
    );
  }

  Widget _buildFinishButton() {
    return RaisedButton.icon(
      icon: Icon(
          _formMode == _FormMode.SignIn ? Icons.lock_open : Icons.person_add),
      label: Text(
        _formMode == _FormMode.SignIn ? 'Sign in' : 'Sign up',
      ),
      onPressed: () async {
        if (!_formKey.currentState.validate()) {
          return;
        }

        _formKey.currentState.save();

        setState(() {
          _isLoading = true;
          _errorMessage = '';
        });

        final accountService =
            Provider.of<AccountService>(context, listen: false);

        try {
          if (_formMode == _FormMode.SignIn) {
            await accountService.signIn(
                _formData['email'], _formData['password']);
          } else {
            await accountService.signUp(
                _formData['email'], _formData['password']);
          }
        } on HttpException catch (e) {
          setState(() {
            _errorMessage = e.message;
          });
        }

        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
      ),
      validator: (value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }

        return null;
      },
      onSaved: (value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter password';
        }

        return null;
      },
      onSaved: (value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
      ),
      validator: (value) {
        if (value != _passwordController.text) {
          return 'Password and confirm password are not matched.';
        }

        return null;
      },
      onSaved: (value) {
        _formData['password'] = value;
      },
    );
  }
}
