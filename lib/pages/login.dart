// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/api/services.dart';
import 'package:miniproject/component/string.dart';
import 'package:miniproject/component/widget.dart';
import 'package:miniproject/model/LoginSuccessModel.dart';
import 'package:miniproject/pages/home.dart';
import 'package:miniproject/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  final WidgetScreen widgetScreen = WidgetScreen();
  final TextScreen textScreen = TextScreen();
  final ImageScreen imageScreen = ImageScreen();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool warnings = false;

  saveData(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: CustomScrollView(
            slivers: [
              SliverLayoutBuilder(
                builder: (BuildContext context, constraints) {
                  return SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: 210,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Image.asset(imageScreen.header, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.all(15),
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Image.network(imageScreen.logo, height: 150),
                          widgetScreen.userInput(usernameController, textScreen.username, TextInputType.text, false, false, "Text", () {}),
                          widgetScreen.userInput(
                            passwordController,
                            textScreen.pw,
                            TextInputType.visiblePassword,
                            true,
                            _passwordVisible,
                            "Text",
                            () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          SizedBox(height: 10),
                          warnings
                              ? Text(
                                  textScreen.warning,
                                  style: GoogleFonts.didactGothic(color: Colors.red),
                                )
                              : SizedBox.shrink(),
                          SizedBox(height: 5),
                          widgetScreen.button(
                            textScreen.signIn,
                            size.width,
                            () {
                              if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
                                setState(() {
                                  warnings = true;
                                });
                              } else {
                                setState(() {
                                  warnings = false;
                                });

                                postLogin(
                                  password: passwordController.text,
                                  username: usernameController.text,
                                ).then(
                                  (response) async {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    var decoded = json.decode(response.body);

                                    Fluttertoast.showToast(
                                      msg: decoded["message"],
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      fontSize: 16,
                                    );

                                    if (response.statusCode == 200 && decoded["message"] == "LOGIN SUCCESS") {
                                      final result = LoginSuccesModel.fromJson(decoded);
                                      saveData("id", result.data.id);
                                      saveData("profileName", result.data.profileName);
                                      saveData("token", result.data.token);
                                      usernameController.clear();
                                      passwordController.clear();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomePage()),
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                textScreen.acc,
                                style: GoogleFonts.didactGothic(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RegisterPage()),
                                ),
                                child: Text(
                                  textScreen.signUp,
                                  style: GoogleFonts.didactGothic(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
