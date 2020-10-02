import 'package:finance/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BudgetModel with ChangeNotifier, DiagnosticableTreeMixin {

  List _periods;
  List get periods => _periods;

  Future<void> fetchPeriods(String username) async {
    _periods = await fetchBudgets(username);
    notifyListeners();
  }

  Future<bool> updateBudget(String username) async {
    final response = await
    http.patch(
      apiBase + "budget/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username" : username,
        'category_name': projectName,
        'amount' : amount.toString()
      }),
    );
  }

}

class Budget {

  String username;
  String categoryName;
  double spent;
  double total;

  Budget(
      {this.username,
        this.categoryName,
        this.spent,
        this.total
      });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
        username: json['username'],
        categoryName: json['category_name'],
        spent: json['spent'],
        total: json['total'],
);
  }
}

Future<List> fetchBudgets(String username) async {
  List periods = new List();
  final response = await http.get(apiBase + "budget/$username");

  if (response.statusCode == 200) {
    List data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      List projects = new List();
      for (int j = 0; j < data[i].length; j++) {
        projects.add(Budget.fromJson(data[i][j]));
      }
      periods.add(projects);
    }

    return periods;
  } else {
    throw Exception('Budgets Not Found');
  }
}