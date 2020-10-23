import 'package:audioplayers/audio_cache.dart';
import 'package:finance/main.dart';
import 'package:finance/model/AuthModel.dart';
import 'package:finance/model/ProfileModel.dart';
import 'package:finance/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: mainColor,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: deepMain,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.account_circle,
                  color: Colors.white,
                  size: 80,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  context.watch<AuthModel>().username.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 100,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: deepMain,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Container(
                    child: context.watch<ProfileModel>().acquiredNum > 3 ?
                    Image(image: AssetImage('assets/pics/medal-gold.png')) :
                    Image(image: AssetImage('assets/pics/medal-bronze.png')),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(children: [
                    Text(context.watch<ProfileModel>().acquiredNum > 3 ? "GOLD" : "BRONZE",
                      style: TextStyle(color: Colors.white, fontSize: 15),),
                    SizedBox(height: 20,),
                    Text(
                      'Badge Earned ${context.watch<ProfileModel>().acquiredNum} / 7',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )
                  ]),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ...buildButtonGroup(context)
        ],
      ),
    ));
  }

  List<Widget> buildButtonGroup(BuildContext context) {
    AudioCache player;
    return [
      Container(
        width: double.infinity,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: RaisedButton(
          color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              "Badges & Achievements",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: mainColor, fontSize: 18),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: mainColor,
            )
          ]),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BadgesRoute()));
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        width: double.infinity,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: RaisedButton(
          color: Color(0xffF24B6C),
          child: Text(
            "Log out",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
          onPressed: () => {
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (Route<dynamic> route) => false)
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    ];
  }
}

class BadgesRoute extends StatefulWidget {
  @override
  _BadgesRouteState createState() => _BadgesRouteState();
}

class _BadgesRouteState extends State<BadgesRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Badges & Achievements'),
      ),
      body: Container(
        color: backgroundColor,
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [...buildCards(context)],
        ),
      ),
    );
  }

  List<Widget> buildCards(BuildContext context) {
    List<BadgeInfo> badges = context.watch<ProfileModel>().allBudges;
    List<Widget> cards = [];
    for (int i = 0; i < badges.length; i++) {
      cards.add(Container(
        height: 100,
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Icon(Icons.flag,
                  size: 70,
                  color: badges[i].acquired ? mainColor : Colors.grey),
            ),
            Expanded(
              flex: 8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    badges[i].badgeName,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: badges[i].acquired ? mainColor : Colors.grey),
                  ),
                  Text(
                    badges[i].badgeDescription,
                    style: TextStyle(
                        fontSize: 15,
                        color: badges[i].acquired ? mainColor : Colors.grey),
                  )
                ],
              ),
            )
          ],
        ),
      ));
    }

    return cards;
  }
}
