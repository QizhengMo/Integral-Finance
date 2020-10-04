import 'package:finance/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthModel with ChangeNotifier, DiagnosticableTreeMixin {
  String _username = '';
  String get username => _username;

  void login(String username) {
    _username = username;
  }

  Future<String> signup(String username, String password, String frequency) async {
    final response = await
    http.post(
      apiBase + "user/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username" : username,
        'password': password,
        'frequency': frequency,
      }),
    );

    if (response.statusCode == 200) {
      return "Successful";
    } else {
      return jsonDecode(response.body)['error'];
    }
  }
}
