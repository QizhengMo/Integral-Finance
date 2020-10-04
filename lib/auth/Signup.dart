import 'package:finance/model/AuthModel.dart';
import 'package:finance/utilities/helperWidgets.dart';
import 'package:finance/utilities/constants.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  var _username = '';
  var _password = '';
  var _frequency = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child:
            // this widget can handle closing keyboard when clicking on other area
            GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                color: mainColor,
              ),
              Container(
                child: CustomPaint(
                  painter: LogoCirclePainter(MediaQuery.of(context).size.width),
                  child: Container(
                    child:
                        Image(image: AssetImage('assets/pics/loginLogo.png')),
                    height: 150,
                    margin: EdgeInsets.only(top: 50, left: 40),
                  ),
                ),
              ),
              Builder(builder: (context) {
                return Container(
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
                      SizedBox(height: 10.0),
                      _buildFrequencyField(),
                      SizedBox(height: 70),
                      _buildSignupBtn(context),
                    ],
                  ),
                );
              }),
            ],
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
          child: TextField(
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: mainColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: mainColor,
              ),
              hintText: 'Enter your Username',
              hintStyle: TextStyle(color: Colors.black54),
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
          child: TextField(

            obscureText: true,
            style: TextStyle(
              color: mainColor,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: mainColor,
              ),
              hintText: 'Enter your Password',
              hintStyle: TextStyle(color: Colors.black54),
            ),
            onChanged: (text) {
              _password = text;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: majorInputBoxStyle,
          height: 60.0,
          child: DropdownButtonFormField(
            style: TextStyle(
              color: mainColor,
              fontFamily: 'OpenSans',
            ),
            hint: Text("Select Frequency", style: TextStyle(fontSize: 16)),
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.lock,
                color: mainColor,
              ),
            ),
            items: ["WEEKLY", "FORTNIGHTLY", "MONTHLY"]
                .map((e) => DropdownMenuItem(
                      child: Text(e),
                      value: e,
                    ))
                .toList(),
            onChanged: (value) => _frequency = value,
          ),
        ),
      ],
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

  void signupRoute(BuildContext context) async {
    if (_frequency.length == 0 || _username.length == 0 || _password.length == 0) {
      mySnack(context, "Please fill all fields.");
      return;
    }

    String result = await context.read<AuthModel>()
        .signup(_username, _password, _frequency);

    if (result == "Successful") {
      Navigator.pop(context, "Signed Up Successful");
    } else {
      mySnack(context, result.toUpperCase());
    }

  }
}

/// Drawing logo background
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
