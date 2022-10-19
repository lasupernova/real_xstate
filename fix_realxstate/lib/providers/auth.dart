import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

import '../models/httpException.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime _expiryDate =
      DateTime.now(); // not nullable in order to be able to use .isAfter() l.20
  late String? _userId;
  Timer?
      _authTimer; // timer to use for auto-logout --> after timer is up passed function (here: logout() ) is automatically called

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

  String? get userID {
    return _userId;
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
      _autoLogout(); // starts _authTimer for autologout on token expiration
      notifyListeners(); // in order to trigger main page's Consumer

      // collect userdata and persist on device
      final prefs = await SharedPreferences
          .getInstance(); // returns a Future, which will eventually return a Sharedpreferences instance -- after adding data to it
      final userData = json.encode({
        'token': _token,
        'userID': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString("userData",
          userData); // add info to persist like this; NOTE: comples data can be added via json.encode(''), as json data is finally always String data

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

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString("userData")!) as Map<
        String,
        dynamic>; // add "!" in order to assure flutter that this variable is not null
    final expiryDate =
        DateTime.parse(extractedUserData["expiryDate"] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _userId = extractedUserData["userID"] as String?;
    _token = extractedUserData["token"] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    // converted logout to async function in order to be able to create Future (Sharedpreferences) and use 'await'
    // function that nulls relevant values for "logout" button, and notifies listeneer so that main page is recreated (back to auth page)
    _token = null;
    _userId = null;
    _expiryDate = DateTime.now();
    _authTimer = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs
        .clear(); // to selectively remove entries prefs.remove(<some_key>) can be used
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToLive = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToLive), logout);
  }
}
