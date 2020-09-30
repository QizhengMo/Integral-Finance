import 'dart:convert';
import 'dart:io';

import 'package:finance/main.dart';
import 'package:finance/model/authModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finance/utilities/constants.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _rememberMe = false;
  var _username = '';
  var _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Builder(
            builder: (context) => Stack(
              children: <Widget>[
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: mainColor,
                ),
                Container(
                  child: CustomPaint(
                    painter:
                        LogoCirclePainter(MediaQuery.of(context).size.width),
                    child: Container(
                      child:
                          Image(image: AssetImage('assets/pics/loginLogo.png')),
                      height: 150,
                      margin: EdgeInsets.only(top: 50, left: 40),
                    ),
                  ),
                ),
                Container(
                  height: double.infinity,
                  margin: EdgeInsets.only(
                      top: 0.3 * MediaQuery.of(context).size.height),
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 30.0),
                      _buildUsernameFiled(),
                      SizedBox(height: 10.0),
                      _buildPasswordField(),
                      SizedBox(height: 10),
                      _buildRememberMeCheckbox(),
                      SizedBox(height: 70),
                      _buildLoginBtn(context),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameFiled() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: inputBoxStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              labelText: 'Username',
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.email,
                color: mainColor,
              ),
            ),
            onChanged: (text) {
              _username = text;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: inputBoxStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'Password',
              prefixIcon: Icon(
                Icons.lock,
                color: mainColor,
              ),
              suffixIcon: Visibility(
                child: Icon(Icons.error),
                visible: false,
              ),
            ),
            onChanged: (text) {
              _password = text;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: mainColor,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: titleTextStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => logInRoute(context),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: mainColor,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: signupRoute,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'SIGN UP',
          style: TextStyle(
            color: mainColor,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void logInRoute(BuildContext context) async {
    final uri = apiBase + "user/";
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'username': '$_username', 'password': '$_password'}),
    );

    if (response.statusCode == 200) {
        if (jsonDecode(response.body)['success']) {
          context.read<AuthModel>().login(_username);
          Navigator.pushNamedAndRemoveUntil(
              context, '/main', (Route<dynamic> route) => false);
        }
      } else {
        print(response.statusCode);
        print(response.body);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(
            'Incorrect Password/Username',
            style: TextStyle(color: mainColor),
          ),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: "Dismiss",
            onPressed: () {
              Scaffold.of(context).hideCurrentSnackBar();
            },
            textColor: Colors.red
          ),
        ));
    }
  }

  void signupRoute() async {
    Navigator.pushNamed(context, '/signup');
  }
}

class LogoCirclePainter extends CustomPainter {
  var vw;
  LogoCirclePainter(this.vw);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Offset center = Offset(vw - 300, 0);

    canvas.drawCircle(center, 300, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
