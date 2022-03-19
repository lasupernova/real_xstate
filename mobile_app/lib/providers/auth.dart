import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../models/httpException.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  // Auth(this._token, this._expiryDate, this._userId);

// REST API documentation from: https://firebase.google.com/docs/reference/rest/auth
  Future<void> signUp(String email, String password) async {
    print("SIGNING UP!!!");
    final Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${dotenv.env['FIREBASE_API_KEY']}");
    // print("URL: $url");  // uncomment for troubleshooting
    final resp = await http.post(url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }));
    final info = jsonDecode(resp.body);
    print(info);
  }

  Future<void> logIn(String email, String password) async {
    print("Login in with email: $email, password: $password!!");
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${dotenv.env['FIREBASE_API_KEY']}");
    print("URL: $url"); // uncomment for troubleshooting
    try {
      final resp = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final info = jsonDecode(resp.body);
      print(info);
      if (info['error'] != null) {
        throw HttpException(info['error']['message']);
      }
    } catch (error) {
      print("RUNNING!");
      throw error.toString();
    }
  }
}
