// ignore_for_file: prefer_const_constructors, prefer_final_fields, unnecessary_null_comparison, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/api/services.dart';
import 'package:miniproject/component/string.dart';
import 'package:miniproject/component/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class AddSupplier extends StatefulWidget {
  const AddSupplier({super.key});

  @override
  State<AddSupplier> createState() => _AddSupplierState();
}

class _AddSupplierState extends State<AddSupplier> {
  final WidgetScreen widgetScreen = WidgetScreen();
  final TextScreen textScreen = TextScreen();

  final namaBarangController = TextEditingController();
  final hargaController = TextEditingController();
  final stokController = TextEditingController();
  final supplieralamatController = TextEditingController();
  final supplieridController = TextEditingController();
  final suppliernamaController = TextEditingController();
  final suppliernotelpController = TextEditingController();

  bool warnings = false;
  String token = "";

  @override
  void initState() {
    super.initState();

    getData();
  }

  getData() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      token = (sharedPrefs.getString('token') ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          textScreen.addSupplier,
          style: GoogleFonts.didactGothic(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(height: 20),
            widgetScreen.userInput(suppliernamaController, textScreen.suppliername, TextInputType.text, false, false, "Text", () {}),
            widgetScreen.userInput(supplieralamatController, textScreen.supplieralamat, TextInputType.text, false, false, "Text", () {}),
            widgetScreen.userInput(suppliernotelpController, textScreen.suppliernamenoTelp, TextInputType.text, false, false, "Text", () {}),
            SizedBox(height: 10),
            warnings
                ? Text(
                    textScreen.warning,
                    style: GoogleFonts.didactGothic(color: Colors.red),
                  )
                : SizedBox.shrink(),
            SizedBox(height: 10),
            widgetScreen.button(
              textScreen.submit,
              size.width,
              () {
                if (suppliernamaController.text.isEmpty || supplieralamatController.text.isEmpty || suppliernotelpController.text.isEmpty) {
                  setState(() {
                    warnings = true;
                  });
                } else {
                  setState(() {
                    warnings = false;
                  });

                  postSupplier(
                    alamat: supplieralamatController.text,
                    namaSupplier: suppliernamaController.text,
                    noTelp: suppliernotelpController.text,
                    token: token,
                  ).then(
                    (response) async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      var decoded = json.decode(response.body);
                      print(response.request);
                      print(response.statusCode);
                      print(response.body);

                      if (response.statusCode == 200) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: decoded["message"],
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.white,
                          fontSize: 16,
                        );
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
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
