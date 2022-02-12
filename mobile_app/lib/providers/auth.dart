import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  // Auth(this._token, this._expiryDate, this._userId);

// REST API documentation from: https://firebase.google.com/docs/reference/rest/auth
  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${dotenv.env['FIREBASE_API_KEY']}");
    // print("URL: $url");  // uncomment for troubleshooting
    http.Response resp = await http.post(url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }));
    final info = jsonDecode(resp.body);
    print(info);
  }
}
