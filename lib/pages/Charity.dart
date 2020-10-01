import 'package:finance/main.dart';
import 'package:finance/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';

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
  Future<List> projects;

  @override
  void initState() {
    projects = fetchProjects();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<List>(
          future: projects,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Widget> cards = [];
              for (int i = 0; i < snapshot.data.length; i++) {
                cards.add(ProjectCard(snapshot.data[i]));
              }
              return Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: ListView(
                    children: cards,
                  ));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  Project project;
  ProjectCard(this.project);

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: InkWell(
          splashColor: mainColor.withOpacity(0.5),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProjectDetailRoute(widget.project)));
          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.project.name,
                  style: TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: LinearPercentIndicator(
                    lineHeight: 18,
                    progressColor:
                        (widget.project.current / widget.project.target) < 1
                            ? mainColor
                            : Colors.red,
                    percent:
                        (widget.project.current / widget.project.target) < 1
                            ? (widget.project.current / widget.project.target)
                            : 1,
                    center: Text(
                      '${widget.project.current} / ${widget.project.target} AUD',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProjectDetailRoute extends StatelessWidget {
  Project project;
  ProjectDetailRoute(this.project);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Project Detail"),
          backgroundColor: mainColor,
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${project.name}",
                    style: TextStyle(fontSize: 30),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Image.network(
                      'https://i.picsum.photos/id/1084/536/354.jpg?grayscale&hmac=Ux7nzg19e1q35mlUVZjhCLxqkR30cC-CarVg-nlIf60'),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "${project.description}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  LinearPercentIndicator(
                    lineHeight: 18,
                    progressColor: (project.current / project.target) < 1
                        ? mainColor
                        : Colors.red,
                    percent: (project.current / project.target) < 1
                        ? (project.current / project.target)
                        : 1,
                    center: Text(
                      '${project.current} / ${project.target} AUD',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Participant Number: ${project.participant}')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlineButton(
                        child: Text('Donate Now'),
                        color: mainColor,
                        textColor: mainColor,
                        highlightedBorderColor: mainColor,
                        onPressed: () => {},
                      )
                    ],
                  ),

                ],
              ),
            )));
  }
}

// below for data fetching

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
      participant: json['participant']
    );
  }
}

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
