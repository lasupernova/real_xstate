import 'package:fix_realxstate/screens/landing.dart';
import 'package:flutter/material.dart';
import 'package:fix_realxstate/screens/auth_screen.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../models/httpException.dart';

class Authcard extends StatefulWidget {
  Authcard({Key? key}) : super(key: key);

  @override
  State<Authcard> createState() => _AuthcardState();
}

class _AuthcardState extends State<Authcard> {
  final GlobalKey<FormState> _formkeyAuth = GlobalKey();
  bool _isLoading = false;
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.Login; // from enum in authScreen file
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Oh Ohhhh..."),
              content: Text(msg),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Okay"))
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formkeyAuth.currentState!.validate()) {
      return;
    }
    _formkeyAuth.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authData["email"]!, _authData["password"]!);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData["email"]!, _authData["password"]!);
      }
    } on HttpException catch (error) {
      var errorMessage = "Authentication failed.";
      if (error.toString().contains("EMAIL_EXISTS")) {
        errorMessage = "This email address already exists!";
      } else if (error.toString().contains("INVALID_EMAIL")) {
        errorMessage = "Please enter a valid email address!";
      } else if (error.toString().contains("WEAK_PASSWORD")) {
        errorMessage = "Password must be at least 6 characters long!";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        errorMessage =
            "User with that email does not exist -- do a spell check :)";
      } else if (error.toString().contains("INVALID_PASSWORD")) {
        errorMessage = "Your password does not match -- do a spell check :)";
      } else {
        errorMessage = "$error";
      }
      _showErrorDialog(errorMessage.toString());
    } catch (error) {
      var errorMessage =
          "Could not authenticate you. Please try again...(later)";
      _showErrorDialog(errorMessage.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
    print("CURRENT AUTHMODE: $_authMode");
  }

  @override
  Widget build(BuildContext context) {
    final deviceSizde = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints:
            BoxConstraints(maxHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSizde.width * 0.75,
        child: Form(
          key: _formkeyAuth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains("@")) {
                      return "Invalid Email Address!";
                    }
                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return "Password needs to be at least 8 characters long";
                    }
                  },
                  onSaved: (value) {
                    _authData["password"] = value!;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: "Confirm Password"),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return "Passwords do not match!";
                            }
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text(
                        _authMode == AuthMode.Login ? "Login!" : "Sign Up!"),
                  ),
                TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        "Switch to ${_authMode == AuthMode.Login ? 'Signup' : 'Login'}"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
