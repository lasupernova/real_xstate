import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../models/httpException.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime _expiryDate = DateTime.now();
  late String _userId;

  // Auth(this._token, this._expiryDate, this._userId);

  bool get isAuth {
    return token != null; // use token-getter to check if _token is null
  }

  String? get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userID {
    return _userId;
  }

  void deleteToken() {
    // function that removes token for "logout" button, and notifies listeneer so that main page is recreated (back to auth page)
    _token = null;
    notifyListeners();
  }

// REST API documentation from: https://firebase.google.com/docs/reference/rest/auth
  Future<void> _authenticate(
      String urlPath, String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlPath?key=${dotenv.env['FIREBASE_API_KEY']}");
    // print("URL: $url"); // uncomment for troubleshooting
    try {
      final resp = await http.post(
        url,
        body: json.encode(
          {
            "email": email,
            "password": password,
            "returnSecureToken": true,
          },
        ),
      );
      final info = jsonDecode(resp.body);
      // print(info);  //uncomment for debugging
      if (info['error'] != null) {
        return Future.error(HttpException(info['error'][
            'message'])); //TODO: figure out why return needs to be used and not 'throw" for HttpException does not work
      }
      _token = info['idToken'];
      _userId = info['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            info['expiresIn'],
          ),
        ),
      );
      notifyListeners(); // in order to trigger main page's Consumer
      return info;
    } catch (error) {
      throw error.toString();
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate("signUp", email, password);
  }

  Future<void> logIn(String email, String password) async {
    return _authenticate("signInWithPassword", email, password);
  }
}
