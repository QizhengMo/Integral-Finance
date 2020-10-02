import 'package:finance/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DonationModel with ChangeNotifier, DiagnosticableTreeMixin {
  int _newHistory = 0;
  int get historyNum => _newHistory;

  void increaseHistory() {
    _newHistory += 1;
    notifyListeners();
  }

  void clearHistory() {
    _newHistory = 0;
    notifyListeners();

  }

  Future<String> donate(String username, String projectName, double amount, Project project) async {

    final response = await
    http.post(
        apiBase + "donation/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "username" : username,
          'project_name': projectName,
          'amount' : amount.toString()
        }),
    );

    if (response.statusCode == 200) {
      project.participant += 1;
      project.current += amount;
      increaseHistory();

      return "Donation Successful";
    } else {
      print(response.body);
      return "Network Failure";
    }

  }




  // Data fetching helper

  Future<List> fetchProjects() async {
    List projects = new List();
    final response = await http.get(apiBase + "charity/project");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        projects.add(Project.fromJson(data[i]));
      }
      return projects;
    } else {
      throw Exception('Projects Not Found');
    }
  }

  Future<List> fetchDonationHistory(String username) async {
    List histories = new List();
    final response = await http.get(apiBase + "donation/$username");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      for (int i = 0; i < data.length; i++) {
        histories.add(DonationHistory.fromJson(data[i]));
      }
      return histories;
    } else {
      throw Exception('Projects Not Found');
    }
  }

}


class Project {
  int projectId;
  int charityId;
  String name;
  String description;
  double target;
  double current;
  int participant;

  Project(
      {this.projectId,
        this.charityId,
        this.name,
        this.description,
        this.target,
        this.current,
        this.participant});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
        projectId: json['project_id'],
        charityId: json['charity_id'],
        name: json['project_name'],
        description: json['project_description'],
        target: json['target'],
        current: json['current_funds'],
        participant: json['participant']);
  }
}


class DonationHistory {
  String projectName;
  double amount;
  String date;

  DonationHistory({this.projectName, this.amount, this.date});

  factory DonationHistory.fromJson(Map<String, dynamic> json) {
    return DonationHistory(
      projectName: json['project_name'],
      amount: json['amount'],
      date: json['date'],
    );
  }
}

