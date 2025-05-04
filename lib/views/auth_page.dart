import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:agrigo_kia/constants/colors.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _emailId = TextEditingController();
  TextEditingController _passWord = TextEditingController();

  String stateCondition = '';
  bool stateAuth = false;
  //
  bool isObscureText = true;
  //
  late Timer _timer;
  File currentJson = File('C:\\Users\\SAC\\Documents/Agrigo/0.0.1-dev/assets/dataX.json');
  bool currentJsonState = true;

  void lastLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    _emailId.text = pref.getString('emailId') ?? '';
    _passWord.text = pref.getString('passWord') ?? '';
  }

  void loadDataW() {
    if (currentJsonState) {
      setState(() {
        currentJson = File('C:\\Users\\SAC\\Documents/Agrigo/0.0.1-dev/assets/dataX.json');
        currentJsonState = false;
      });
    } else {
      setState(() {
        currentJson = File('C:\\Users\\SAC\\Documents/Agrigo/0.0.1-dev/assets/dataY.json');
        currentJsonState = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), (_) => loadDataW());
    lastLogin();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 32,
        elevation: 0,
        backgroundColor: kPrimaryColor,
        leading: Builder(
            builder: (context) => IconButton(
                  icon: Icon(
                    Icons.flutter_dash,
                    color: kWhiteColor,
                    size: 16,
                  ),
                  onPressed: null,
                )),
        title: WindowTitleBarBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: MoveWindow(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 8,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Agrigo',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          WidgetSpan(
                            child: Transform.translate(
                              offset: Offset(0.0, -8.0),
                              child: Text(
                                ' BETA',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
              Row(
                children: [
                  MinimizeWindowButton(
                    colors: kWindowBtnColor,
                  ),
                  MaximizeWindowButton(
                    colors: kWindowBtnColor,
                  ),
                  CloseWindowButton(
                    colors: kWindowCloseBtnColor,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(children: [
        Container(
          child: Lottie.file(
            currentJson,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.75),
        ),
        Center(
          child: Container(
            height: 753,
            width: 536,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(36),
            ),
            child: Padding(
              padding: EdgeInsets.all(80.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Welcome to Agrigo',
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Soil Test Reporting Portal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: _emailId,
                    decoration: InputDecoration(
                      hintText: 'Employee Code',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    controller: _passWord,
                    obscureText: isObscureText,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscureText = !isObscureText;
                          });
                        },
                        icon: Icon(
                          isObscureText ? Icons.visibility_off : Icons.visibility,
                          color: kGreyColor,
                        ),
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    height: 48,
                    width: 260,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.resolveWith(
                            (states) => EdgeInsets.only(top: 14, bottom: 14, left: 110, right: 110)),
                        backgroundColor: MaterialStateColor.resolveWith((states) => kPrimaryColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(36.0), side: BorderSide.none),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute<void>(builder: (BuildContext context) => HomePage()));
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 260,
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      fillColor: Color(0xFF1299F5),
                      onPressed: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage('assets/outlook-logo.png'),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Text(
                            'Continue with Microsoft',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: null,
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(fontSize: 12.5, color: Colors.grey),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: null,
                        child: Text(
                          'Change Password',
                          style: TextStyle(fontSize: 12.5, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16,
                    child: stateAuth
                        ? Text(
                            stateCondition,
                            style: TextStyle(color: kWindowCloseBtnColor.mouseOver),
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

Future<String> signInWithEmail(String emailId, String passWord) async => await http
        .post(
            Uri.parse(
                'http://localhost:9099/identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA0Ws3_H4Oh96knqQsnFT50OXXRvXv4PQQ'),
            headers: <String, String>{
              'Content-Type': 'application/json',
            },
            body: json.encode({"email": emailId, "password": passWord, "returnSecureToken": false}))
        .then((responseAuth) {
      return responseAuth.body;
    });
