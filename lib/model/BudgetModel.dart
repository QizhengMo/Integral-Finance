import 'dart:math';

import 'package:finance/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BudgetModel with ChangeNotifier, DiagnosticableTreeMixin {

  List _periods;
  List get periods => _periods;

  List _budgets;
  List get budgets => _budgets;

  double _totalLeft = 0;
  double get totalLeft => _totalLeft;

  int _currentIndex = 0;
  int get length => _currentIndex;

  Future<void> fetchPeriods(String username) async {
    _periods = await fetchBudgets(username);
    _currentIndex = _periods.length - 1;
    _budgets = _periods[_currentIndex];
    calculateTotal();
    notifyListeners();
  }

  void calculateTotal() {
    if (_periods == null) {
      return;
    }

    _totalLeft = 0;
    for (Budget b in _budgets) {
      _totalLeft += max((b.total - b.spent),0);
    }
  }

  List getCurrentCategories() {
    List<String> categories = new List();
    List currentBudgets = _periods[_periods.length - 1];
    for (Budget budget in currentBudgets) {
      categories.add(budget.categoryName);
    }
    print(categories.toString());
    return categories;
  }

  Future<bool> updateBudget(String username, String categoryName, double amount)
  async {

    final response = await
    http.put(
      apiBase + "budget/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username" : username,
        'category_name': categoryName,
        'total' : amount.toString()
      }),
    );

    if (response.statusCode == 200) {
      fetchPeriods(username);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addExpense(String username, String categoryName, double spent)
  async {

    final response = await
    http.patch(
      apiBase + "budget/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username" : username,
        'category_name': categoryName,
        'spent' : spent.toString()
      }),
    );

    if (response.statusCode == 200) {
      fetchPeriods(username);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addCategory(String username, String categoryName)
  async {

    final response = await
    http.post(
      apiBase + "category/",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "username" : username,
        'category_name': categoryName,
      }),
    );

    if (response.statusCode == 200) {
      fetchPeriods(username);
      return true;
    } else {
      return false;
    }
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