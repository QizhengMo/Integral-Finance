import 'dart:math';

import 'package:finance/main.dart';
import 'package:finance/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            buildHomeAppbar(),
            SliverList(
                delegate: SliverChildListDelegate([
                  BudgetCard('Home', 500, 100),
                  BudgetCard('Home', 500, 100),
                  BudgetCard('Home', 500, 100),
                  BudgetCard('Home', 500, 600),

                ]),
              ),
          ],
        )
    );
  }


  Widget buildHomeAppbar() {
    return
      SliverAppBar(
        pinned: true,
        floating: true,
        expandedHeight: 200,
        flexibleSpace: FlexibleSpaceBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories', style: TextStyle(fontSize: 20),),
              IconButton(
                icon: Icon(Icons.playlist_add, color: Colors.white),
                iconSize: 30,
                onPressed: () => {} ,
              )
            ]
          ),
          titlePadding: EdgeInsets.only(left: 20),
          background: Container(
            padding: EdgeInsets.only(top: 40,left: 20,right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Budget Left', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 30)),
                Text('\$ 450', style: TextStyle(color: Colors.white, fontSize: 30))
              ],
            ),
          ),
        ),
      );
  }
}

class BudgetCard extends StatefulWidget {

  var category;
  double total;
  double spent;

  BudgetCard(this.category, this.total, this.spent);

  @override
  _BudgetCardState createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {

  double newAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    //view width and height
    double vw = MediaQuery.of(context).size.width;
    double vh = MediaQuery.of(context).size.height;

    final AlertDialog dialog = inputDialog(context);

    return
      Container(
        height: 120,
        child: Card(
          child: InkWell(
            splashColor: mainColor.withOpacity(0.5),
            onTap: () =>{ showDialog<void>(context: context, builder: (context) => dialog)
                .then(
                (val) {updateTotal();}
            )},
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(this.widget.category, style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: mainColor),),
                      Visibility(
                        child: Icon(
                          Icons.priority_high,
                          color: Colors.red,
                        ),
                        visible: (widget.spent / widget.total) > 1,
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  LinearPercentIndicator(
                    width: vw - 50,
                    lineHeight: 18,
                    progressColor: (widget.spent / widget.total) < 1 ? mainColor : Colors.red,
                    percent: (widget.spent / widget.total) < 1 ? (widget.spent / widget.total) : 1,
                    center: Text(
                      '${widget.spent} / ${widget.total}',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget inputDialog(context) {
    return
      AlertDialog(
        title: Text(this.widget.category),
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
            color: Color(0xff4BD6F2),
            onPressed: () => Navigator.pop(context,1),
            child: Text('SAVE'),
          ),
        ],

      );
  }

  Widget inputArea() {
    return
      TextFormField(
        keyboardType: TextInputType.number,
        initialValue: '',
        decoration: InputDecoration(
          labelText: 'Budget Amount',
          labelStyle: TextStyle(
            color: mainColor,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: mainColor),
          ),
        ),
        onChanged: (text) => {this.newAmount = double.parse(text)},
      );
  }

  void updateTotal() {
    setState(() {
      this.widget.total = 400;
    });
  }
}
