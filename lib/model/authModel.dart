import 'package:flutter/foundation.dart';
import 'dart:convert';

class AuthModel with ChangeNotifier, DiagnosticableTreeMixin {
  String _username = '';
  String get username => _username;

  void login(String username) {
    _username = username;
  }

  /// Makes readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('username', username));
  }
}
