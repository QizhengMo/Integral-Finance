import 'dart:collection';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart';
import 'package:finance/pages/Profile.dart';
import 'package:finance/utilities/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileModel with ChangeNotifier, DiagnosticableTreeMixin {
  List<BadgeInfo> _allBadges = [
    BadgeInfo(
        badgeName: "Starting Saver",
        badgeDescription: "Go under your set budget for the first time",
        acquired: false),
    BadgeInfo(
        badgeName: "Tidy & Organised",
        badgeDescription: "Add 3 or more categories to a budget cycle",
        acquired: false),
    BadgeInfo(
        badgeName: "Smart Saver",
        badgeDescription: "Have some budget left after each cycle",
        acquired: false),
    BadgeInfo(
        badgeName: "Good Samaritan",
        badgeDescription: "Donate to a charity for the first time",
        acquired: false),
    BadgeInfo(
        badgeName: "Avid Donor",
        badgeDescription: "Make three donations",
        acquired: false),
    BadgeInfo(
        badgeName: "Philanthropist",
        badgeDescription: "Make six donations",
        acquired: false),
    BadgeInfo(
        badgeName: "Organised",
        badgeDescription: "Have six or more custom categories in your budget.",
        acquired: false)
  ];

  List get allBudges => _allBadges;

  bool isFirstTime = true;

  int acquiredNum = 0;
  List<String> newBadgeNames = [];

  Future<bool> fetchBadge(String username) async {
    bool foundNew = false;

    final response = await
    http.get(
      apiBase + "badge/$username",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      acquiredNum = 0;
      for (int i = 0; i < data.length; i++) {
        for (BadgeInfo badge in _allBadges) {
          if (badge.badgeName == data[i]['badge_name']) {
            badge.acquired = true;
            acquiredNum += 1;
          }
        }

        if (data[i]['new'] == 1) {
          foundNew = true;
          newBadgeNames.add(data[i]['badge_name']);
        }
      }

      // magic sorting based if the badge is acquired
      _allBadges.sort((a, b) => a.acquired && b.acquired ? 0 :
        a.acquired && !b.acquired ? -1 : 1);

      notifyListeners();
    }

    return foundNew;
  }

  ///
  /// This Method is here to avoid repeating code in individual pages
  Future<void> showBadgeDialog(BuildContext context) async {

    if (newBadgeNames.length == 0) {
      return;
    }

    final player = AudioCache(prefix: 'assets/sounds/');
    player.play('popup.mp3');

    await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          backgroundColor: mainColor,
          title: Center(
              child: Text(
            "Congratulation!",
            style: TextStyle(color: Colors.white),
          )),
          content: Container(
            height: 120,
            child: Column(children: [
              Text("${newBadgeNames.removeLast().toUpperCase()} UNLOCKED",
                  style: TextStyle(color: Colors.white)),
              Icon(Icons.flag, size: 100, color: Colors.white,)
            ]),
          ),
          actions: <Widget>[
            FlatButton(
              child:
                  Text('CLOSE', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        )
    );

    showBadgeDialog(context);
  }
}

class BadgeInfo {
  String badgeName;
  String badgeDescription;
  bool acquired;

  BadgeInfo({
    this.badgeName,
    this.badgeDescription,
    this.acquired,
  });
}
