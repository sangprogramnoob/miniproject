// ignore_for_file: prefer_const_constructors, avoid_print, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/component/string.dart';
import 'package:miniproject/component/widget.dart';
import 'package:miniproject/api/services.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final WidgetScreen widgetScreen = WidgetScreen();
  final TextScreen textScreen = TextScreen();
  final ImageScreen imageScreen = ImageScreen();
  final profileNameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool warnings = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
                    background: Image.network(imageScreen.header2, fit: BoxFit.cover),
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
                        widgetScreen.userInput(profileNameController, textScreen.pname, TextInputType.text, false, false, "Text", () {}),
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
                          textScreen.signUp,
                          size.width,
                          () async {
                            if (profileNameController.text.isEmpty || usernameController.text.isEmpty || passwordController.text.isEmpty) {
                              setState(() {
                                warnings = true;
                              });
                            } else {
                              setState(() {
                                warnings = false;
                              });

                              postRegister(
                                password: passwordController.text,
                                profileName: profileNameController.text,
                                username: usernameController.text,
                              ).then(
                                (response) async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  var decoded = json.decode(response.body);

                                  if (response.statusCode == 200) {
                                    Fluttertoast.showToast(
                                      msg: decoded["message"],
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      fontSize: 16,
                                    );
                                    if (decoded["message"] == "REGISTER SUCCESSFUL") {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: decoded["error"],
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      textColor: Colors.white,
                                      fontSize: 16,
                                    );
                                  }
                                },
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
