import 'dart:math';

import 'package:finance/model/AuthModel.dart';
import 'package:finance/model/BudgetModel.dart';
import 'package:finance/utilities/helperWidgets.dart';
import 'package:provider/provider.dart';

import 'package:finance/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final categoryInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<BudgetModel>()
        .fetchPeriods(context.read<AuthModel>().username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            buildHomeAppbar(),
            SliverList(delegate: SliverChildListDelegate(buildCards())),
      ],
    ));
  }

  List<Widget> buildCards() {
    List periods = context.watch<BudgetModel>().periods;

    if (periods == null) {
      return [
        SizedBox(
          height: 100,
        ),
        Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(mainColor)),
        )
      ];
    } else {
      List currentPeriod = periods[periods.length - 1];
      List<Widget> cards = new List();
      for (Budget budget in currentPeriod) {
        cards.add(BudgetCard(budget.categoryName, budget.total, budget.spent));
      }
      return cards;
    }
  }

  Widget buildHomeAppbar() {
    final AlertDialog dialog = buildCategoryInputDialog(context);

    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 200,
      flexibleSpace: FlexibleSpaceBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(
                'Categories',
                style: TextStyle(fontSize: 20),
              ),
              IconButton(
                icon: Icon(Icons.playlist_add, color: Colors.white),
                iconSize: 30,
                onPressed: () => {
                    showDialog<void>(context: context, builder: (context) => dialog)
                  },
              )
            ]),
        titlePadding: EdgeInsets.only(left: 20),
        background: Container(
          padding: EdgeInsets.only(top: 40, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Budget Left',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30)),
              Text('\$ ${context.watch<BudgetModel>().totalLeft}',
                  style: TextStyle(color: Colors.white, fontSize: 30))
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// Add category popup dialog
  ///
  Widget buildCategoryInputArea() {

    return TextFormField(
      controller: categoryInput,
      keyboardType: TextInputType.number,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Category Name',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget buildCategoryInputDialog(context) {
    return AlertDialog(
      backgroundColor: mainColor,
      title: Text("New Category", style: TextStyle(color: Colors.white),),
      content: buildCategoryInputArea(),
      actions: [
        RaisedButton(
          textColor: Colors.white,
          color: Color(0xffF24B6C),
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        RaisedButton(
          textColor: mainColor,
          color: Colors.white,
          onPressed: () => {updateBudget(context)},
          child: Text('SAVE'),
        ),
      ],
    );
  }

  Future<void> updateBudget(BuildContext context) async {

    if (categoryInput.text.length == 0) {
      Navigator.pop(context);
      mySnack(context, "Please enter category name!");
      return;
    }

    bool result = await context.read<BudgetModel>().addCategory(
                          context.read<AuthModel>().username
                          , categoryInput.text);

    if (result) {
      Navigator.pop(context);
      mySnack(context, "New Category Added!");
    } else {
      Navigator.pop(context);
      mySnack(context, "Network/Server Failure!");
    }
  }
}

class BudgetCard extends StatefulWidget {
  final String category;
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

    final AlertDialog dialog = buildBudgetCardInputDialog(context);

    return Container(
      height: 120,
      child: Card(
        child: InkWell(
          splashColor: mainColor.withOpacity(0.5),
          onTap: () => {
            showDialog<void>(context: context, builder: (context) => dialog)},

          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      this.widget.category,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: mainColor),
                    ),
                    Visibility(
                      child: Icon(
                        Icons.priority_high,
                        color: Colors.red,
                      ),
                      visible: (widget.spent / widget.total) > 1,
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                LinearPercentIndicator(
                  width: vw - 50,
                  lineHeight: 18,
                  animationDuration: 2000,
                  restartAnimation: false,
                  animation: true,
                  animateFromLastPercent: true,
                  progressColor: (widget.spent / widget.total) < 1
                      ? mainColor
                      : Colors.red,
                  percent: (widget.spent / widget.total) < 1
                      ? (widget.spent / widget.total)
                      : 1,
                  center: Text(
                    '${widget.spent} / ${widget.total}',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///
  /// Budget Cards popup dialog
  ///
  Widget buildBudgetCardInputArea() {
    return TextFormField(
      keyboardType: TextInputType.number,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Budget Amount',
        labelStyle: TextStyle(
          color: Colors.white,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onChanged: (text) => {this.newAmount = double.parse(text)},
    );
  }

  Widget buildBudgetCardInputDialog(context) {
    return AlertDialog(
      backgroundColor: mainColor,
      title: Text(this.widget.category, style: TextStyle(color: Colors.white),),
      content: buildBudgetCardInputArea(),
      actions: [
        RaisedButton(
          textColor: Colors.white,
          color: Color(0xffF24B6C),
          onPressed: () => Navigator.pop(context),
          child: Text('CANCEL'),
        ),
        RaisedButton(
          textColor: mainColor,
          color: Colors.white,
          onPressed: () => updateBudget(context),
          child: Text('SAVE'),
        ),
      ],
    );
  }

  Future<void> updateBudget(BuildContext context) async {

    if (newAmount == 0) {
      Navigator.pop(context);
      mySnack(context, 'Invalid Amount!');
      return;
    }
    bool result = await context.read<BudgetModel>().updateBudget(
        context.read<AuthModel>().username, widget.category, newAmount);

    Navigator.pop(context);

    if (result) {
      mySnack(context, 'Update Successfully!');
    } else {
      mySnack(context, 'Network Failure!');
    }
  }

}
