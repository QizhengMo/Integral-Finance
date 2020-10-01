import 'package:flutter/foundation.dart';
import 'dart:convert';

class DonationModel with ChangeNotifier, DiagnosticableTreeMixin {
  int _newHistory = 0;
  int get historyNum => _newHistory;

  bool increaseHistory() {

    _newHistory += 1;
    notifyListeners();
  }

  void clearHistory() {
    _newHistory = 0;
    notifyListeners();

  }

}
