import 'dart:convert';

import 'package:finance/model/AuthModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:finance/utilities/constants.dart';
import 'package:finance/utilities/helperWidgets.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _rememberMe = false;
  bool _canInput = true;
  var _username = '';
  var _password = '';
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRememberMe();
  }

  void loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('remember')) {
      setState(() {
        _username = prefs.getString('username') ?? '';
        _password = prefs.getString('password') ?? '';
        usernameController.text = _username;
        passwordController.text = _password;
        _rememberMe = true;
      });
    } else {
      _rememberMe = false;
    }

  }

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
                        _buildSignupBtn(context),
                      ],
                    ),
                  )
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
          decoration: majorInputBoxStyle,
          height: 60.0,
          child: TextFormField(
            enabled: _canInput,
            keyboardType: TextInputType.name,
            controller: usernameController,
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
          decoration: majorInputBoxStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            controller: passwordController,
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

  Widget _buildSignupBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => signupRoute(context),
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
    _canInput = false;
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
      context.read<AuthModel>().login(_username);
      Navigator.pushNamedAndRemoveUntil(
          context, '/main', (Route<dynamic> route) => false);


      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        prefs.setString('username', _username);
        prefs.setString('password', _password);
        prefs.setBool('remember', true);
      } else {
        prefs.remove('username');
        prefs.remove('password');
        prefs.setBool('remember', false);
      }

    } else {
      _canInput = true;
      mySnack(context, 'Incorrect Password/Username');
    }
  }

  void signupRoute(BuildContext context) async {
    final result = await Navigator.pushNamed(context, '/signup');

    if (result != null && result.runtimeType == String) {
      mySnack(context, result);
    }
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
