import 'package:finance/main.dart';
import 'package:finance/model/AuthModel.dart';
import 'package:finance/utilities/constants.dart';
import 'package:finance/utilities/helperWidgets.dart';
import 'package:flutter/cupertino.dart';

import 'Charity.dart';
import 'settings.dart';
import 'Investment.dart';
import 'Home.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:finance/model/BudgetModel.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  double newAmount = 0;
  String selectedCategory = "";

  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    Home(),
    Investment(),
    Charity(),
    Profile(),
  ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home(); // Our first view in viewport

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return (
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => {
                  setState(() {
                    currentScreen = Home();
                    currentTab = 0;
                  }),
                  popAddDialog(context)
                },
                backgroundColor: Colors.white,
                foregroundColor: mainColor,
              )
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Home();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.home,
                          color: currentTab == 0 ? mainColor : Colors.grey,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: currentTab == 0 ? mainColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Investment();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.attach_money,
                          color: currentTab == 1 ? mainColor : Colors.grey,
                        ),
                        Text(
                          'Investment',
                          style: TextStyle(
                            color: currentTab == 1 ? mainColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Charity();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.credit_card,
                          color: currentTab == 2 ? mainColor : Colors.grey,
                        ),
                        Text(
                          'Charity',
                          style: TextStyle(
                            color: currentTab == 2 ? mainColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Profile();
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          color: currentTab == 3 ? mainColor : Colors.grey,
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: currentTab == 3 ? mainColor : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void popAddDialog(BuildContext context) {
    final AlertDialog dialog = inputDialog(context);
    showDialog<void>(context: context, builder: (context) => dialog);
  }

  // Below Are helpers building dialog
  Widget inputArea() {
    return Container(
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: TextStyle(color: Colors.white),
              fillColor: Colors.white,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onChanged: (text) => {this.newAmount = double.parse(text)},
          ),
          DropdownButtonFormField(
            dropdownColor: mainColor,
            decoration: InputDecoration(
                hintText: "Select Category",
                hintStyle: TextStyle(color: Colors.white)),
            items: context
                .read<BudgetModel>()
                .getCurrentCategories()
                .map((e) => DropdownMenuItem(
                    value: e.toString(),
                    child: Text(
                      e.toString(),
                      style: TextStyle(color: Colors.white),
                    )))
                .toList(),
            onChanged: (value) {
              selectedCategory = value;
            },
          )
        ],
      ),
    );
  }

  Widget inputDialog(context) {
    return AlertDialog(
      backgroundColor: mainColor,
      title: Text(
        "Record Expense",
        style: TextStyle(color: Colors.white),
      ),
      content: inputArea(),
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
          onPressed: () => {
            addExpense(context)
          },
          child: Text('SAVE'),
        ),
      ],
    );
  }

  Future<void> addExpense(BuildContext context) async {
    Navigator.pop(context);
    if (selectedCategory == "" || newAmount == 0) {
      mySnack(context, "Invalid Input!");
    }
    bool result = await context.read<BudgetModel>()
        .addExpense(context.read<AuthModel>().username, selectedCategory, newAmount);

    if (result) {
      mySnack(context, "Expense Recorded!");
    } else {
      mySnack(context, "Network/Server Failure!");
    }
  }
}
