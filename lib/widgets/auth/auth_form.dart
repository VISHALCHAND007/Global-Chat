import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_chat/pickers/image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({required this.onSubmit, required this.isLoading, super.key});

  final bool isLoading;
  final void Function({
    required String email,
    required String password,
    String? username,
    File? userImg,
    required bool isLogin,
    required BuildContext ctx,
  })
  onSubmit;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _showPassword = true;
  final _formKey = GlobalKey<FormState>();
  String? _userEmail;
  String? _username;
  String? _userPassword;
  File? _userImg;
  var _isLogin = true;
  late final scaffoldMessenger = ScaffoldMessenger.of(context);
  late final theme = Theme.of(context);

  void _saveForm() {
    FocusScope.of(context).unfocus();

    if (_userImg == null && !_isLogin) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text("Please select an image!"),
          backgroundColor: theme.colorScheme.error,
          showCloseIcon: true,
        ),
      );
      return;
    }
    var isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();

      widget.onSubmit(
        email: _userEmail!.trim(),
        password: _userPassword!.trim(),
        username: _username?.trim(),
        userImg: _userImg,
        isLogin: _isLogin,
        ctx: context,
      );
    }
  }

  void _onImgSelected(File? userImg) {
    _userImg = userImg;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                mainAxisSize: .min,
                children: [
                  if (!_isLogin) ImagePicker(onImgSelected: _onImgSelected),
                  TextFormField(
                    key: ValueKey("email"),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: const Text("Email"),
                      suffixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains("@")) {
                        return "Invalid Email";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: ValueKey("username"),
                      decoration: InputDecoration(
                        label: const Text("Username"),
                        suffixIcon: Icon(Icons.account_circle),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return "Please enter at least 4 characters";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value;
                      },
                    ),
                  TextFormField(
                    key: ValueKey("password"),
                    decoration: InputDecoration(
                      label: const Text("Password"),
                      suffixIcon: IconButton(
                        icon: _showPassword
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                        onPressed: () => setState(() {
                          _showPassword = !_showPassword;
                        }),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 7) {
                        return "Password must be at least 7 characters long.";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userPassword = value;
                    },
                    obscureText: _showPassword,
                  ),
                  SizedBox(height: 10),
                  widget.isLoading
                      ? CircularProgressIndicator()
                      : Column(
                          children: [
                            ElevatedButton(
                              onPressed: _saveForm,
                              child: Text(_isLogin ? "Login" : "Signup"),
                            ),
                            TextButton(
                              onPressed: () => setState(() {
                                _isLogin = !_isLogin;
                              }),
                              style: ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                _isLogin
                                    ? "Create new account"
                                    : "I already have an account",
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
