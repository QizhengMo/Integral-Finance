import 'package:badges/badges.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:finance/model/DonationModel.dart';
import 'package:finance/model/authModel.dart';

import 'package:finance/utilities/constants.dart';
import 'package:finance/utilities/helperWidgets.dart';

class Charity extends StatefulWidget {
  @override
  _CharityState createState() => _CharityState();
}

class _CharityState extends State<Charity> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 1) {
          this.setState(() {
            context.read<DonationModel>().clearHistory();
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        controller: _tabController,
        labelColor: mainColor,
        indicatorColor: mainColor,
        labelPadding: EdgeInsets.only(top: 30),
        tabs: [
          Tab(
            icon: Icon(Icons.assignment),
            text: "Projects",
          ),
          Tab(
            icon: Badge(
                badgeColor: mainColor,
                badgeContent:
                    Text('${context.watch<DonationModel>().historyNum}'),
                animationType: BadgeAnimationType.scale,
                showBadge: context.watch<DonationModel>().historyNum != 0,
                child: Icon(Icons.history)),
            text: "History",
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ProjectTab(),
          HistoryTab(),
        ],
      ),
    );
  }
}

///
///
///
/// PROJECT TAB

class ProjectTab extends StatefulWidget {
  @override
  _ProjectTabState createState() => _ProjectTabState();
}

class _ProjectTabState extends State<ProjectTab> {
  Future<List> projects;

  @override
  void initState() {
    super.initState();
    projects = context.read<DonationModel>().fetchProjects();
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
  final Project project;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.project.name,
                      style: TextStyle(
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ],
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

class ProjectDetailRoute extends StatefulWidget {
  final Project project;

  ProjectDetailRoute(this.project);

  @override
  _ProjectDetailRouteState createState() => _ProjectDetailRouteState();
}

class _ProjectDetailRouteState extends State<ProjectDetailRoute> {
  final donatePopupController = TextEditingController();
  double current;
  int participant;

  @override
  void initState() {
    super.initState();
    current = widget.project.current;
    participant = widget.project.participant;
  }

  @override
  Widget build(BuildContext detailPageContext) {
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
                    "${widget.project.name}",
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
                    "${widget.project.description}",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  LinearPercentIndicator(
                    animation: true,
                    animateFromLastPercent: true,
                    animationDuration: 2000,
                    lineHeight: 18,
                    progressColor: (current / widget.project.target) < 1
                        ? mainColor
                        : Colors.red,
                    percent: (current / widget.project.target) < 1
                        ? (current / widget.project.target)
                        : 1,
                    center: Text(
                      '$current / ${widget.project.target} AUD',
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
                      Text('Participant Number: $participant')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (BuildContext BtnContext) {
                          return OutlineButton(
                            child: Text('Donate Now'),
                            color: mainColor,
                            textColor: mainColor,
                            highlightedBorderColor: mainColor,
                            onPressed: () async {
                              String result = await showDialog<String>(
                                  context: BtnContext,
                                  builder: (context) => inputDialog(context));

                              print(result);
                              if (result != null) {
                                mySnack(BtnContext, result);
                              }
                            },
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            )));
  }

  Widget inputArea() {
    return TextFormField(
      controller: donatePopupController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Donation Amount',
        labelStyle: TextStyle(
          color: mainColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor),
        ),
      ),
    );
  }

  Widget inputDialog(context) {
    return AlertDialog(
      title: Text('Donate'),
      content: inputArea(),
      actions: [
        RaisedButton(
          textColor: Colors.white,
          color: Color(0xffF24B6C),
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        RaisedButton(
          textColor: Colors.white,
          color: mainColor,
          onPressed: () => donate(context),
          child: Text('Confirm'),
        ),
      ],
    );
  }

  Future<void> donate(BuildContext context) async {
    double amount;
    try {
      amount = double.parse(donatePopupController.text);
    } catch (Exception) {
      Navigator.pop(context, "Invalid Amount");
      return;
    }

    String result = await context.read<DonationModel>()
        .donate(context.read<AuthModel>().username, widget.project.name, amount, widget.project);

    if (result == "Donation Successful") {
      setState(() {
        participant += 1;
        current += amount;
      });
    }

    Navigator.pop(context,result);
  }
}

///
///
/// HISTORY TAB

class HistoryTab extends StatefulWidget {
  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  Future<List> histories;

  @override
  void initState() {
    super.initState();
    histories = context
        .read<DonationModel>()
        .fetchDonationHistory(context.read<AuthModel>().username);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder<List>(
          future: histories,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              double total = 0;
              for (int i = 0; i < snapshot.data.length; i++) {
                total += snapshot.data[i].amount;
              }
              return Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Card(
                        color: mainColor,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: (MediaQuery.of(context).size.width -
                                          100) *
                                      0.5,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'THANK YOU! ${context.watch<AuthModel>().username.toUpperCase()}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'You have donated: ',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ]),
                                ),
                                Container(
                                  width: (MediaQuery.of(context).size.width -
                                          100) *
                                      0.5,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${snapshot.data.length} TIMES',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          '$total AUD',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ]),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Project Name',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Amount',
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Container(
                                padding: EdgeInsets.all(20),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('No. $index'),
                                            Text(snapshot
                                                .data[index].projectName),
                                            Text(snapshot.data[index].date)
                                          ]),
                                      Text(snapshot.data[index].amount
                                          .toString())
                                    ])),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );

              // error handling
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            // By default, show a loading spinner.
            return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(mainColor));
          },
        ),
      ),
    );
  }
}
