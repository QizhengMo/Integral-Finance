import 'package:finance/utilities/constants.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class Charity extends StatefulWidget {
  @override
  _CharityState createState() => _CharityState();
}

class _CharityState extends State<Charity> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: TabBar(
            labelColor: mainColor,
            indicatorColor: mainColor,
            labelPadding: EdgeInsets.only(top: 30),
            tabs: [
              Tab(
                icon: Icon(Icons.assignment),
                text: "Projects",
              ),
              Tab(
                icon: Icon(Icons.history),
                text: "History",
              ),
            ],
          ),
          body: TabBarView(
            children: [
              ProjectTab(),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectTab extends StatefulWidget {
  @override
  _ProjectTabState createState() => _ProjectTabState();
}

class _ProjectTabState extends State<ProjectTab> {
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}


class Project {
  final int projectId;
  final int charityId;
  final String name;
  final String description;
  final double target;
  final double current;

  Project({this.projectId, this.charityId, this.name, this.description,
    this.target, this.current});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['project_id'],
      charityId: json['charity_id'],
      name: json['project_name'],
      description: json['project_description'],
      target: json['target'],
      current: json['current_funds'],
    );
  }
}

Future<Project> fetchProjects() async {

  final response =
  await http.get(apiBase + "charity");

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Project.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}