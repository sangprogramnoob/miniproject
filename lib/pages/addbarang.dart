// ignore_for_file: prefer_const_constructors, prefer_final_fields, unnecessary_null_comparison, sized_box_for_whitespace, avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/api/services.dart';
import 'package:miniproject/component/string.dart';
import 'package:miniproject/component/widget.dart';
import 'package:miniproject/model/SupplierModel.dart';
import 'package:miniproject/api/config.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class AddBarangPage extends StatefulWidget {
  const AddBarangPage({super.key});

  @override
  State<AddBarangPage> createState() => _AddBarangPageState();
}

class _AddBarangPageState extends State<AddBarangPage> {
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

  bool onLoadMore2 = false;
  int page2 = 1;
  SupplierModel? _dataSupplier;
  List _supplier = [];
  bool isLoading2 = false;
  int? selectedindex;

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
    await getSupplier(1);
  }

  getSupplier(int pages) async {
    setState(() {
      onLoadMore2 = true;
    });
    final futuresupplier = Config.getSupplier(token, pages);

    if (pages == 1) {
      _supplier.clear();
      setState(() {
        page2 = 1;
      });
    } else {
      //
    }
    await futuresupplier.then((value) {
      if (value != null) {
        setState(() {
          _dataSupplier = value;
        });
      }
    });
    if (_dataSupplier == null || _dataSupplier!.data == null) {
      if (!mounted) return;
      setState(() {
        onLoadMore2 = false;
        isLoading2 = true;
        return;
      });
    } else {
      setState(() {
        var data = _dataSupplier!.data;
        for (var i = 0; i < data.length; i++) {
          _supplier.add(
            {
              "supplierid": data[i].id,
              "suppliernamaSupplier": data[i].namaSupplier,
              "suppliernoTelp": data[i].noTelp,
              "supplieralamat": data[i].alamat,
            },
          );
        }
      });
    }
    setState(() {
      onLoadMore2 = false;
      isLoading2 = true;
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
          textScreen.addbarang,
          style: GoogleFonts.didactGothic(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(height: 20),
            widgetScreen.userInput(namaBarangController, textScreen.namaBarang, TextInputType.text, false, false, "Text", () {}),
            widgetScreen.userInput(hargaController, textScreen.harga, TextInputType.text, false, false, "Number", () {}),
            widgetScreen.userInput(stokController, textScreen.stok, TextInputType.text, false, false, "Number", () {}),
            Expanded(
              child: Container(
                width: size.width,
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: RefreshLoadmore(
                    onRefresh: () => getSupplier(1),
                    isLastPage: false,
                    onLoadmore: () async {
                      await Future.delayed(Duration(milliseconds: 500), () {
                        setState(
                          () {
                            onLoadMore2 = true;
                            page2 = page2 + 1;
                          },
                        );
                        getSupplier(page2);
                        setState(
                          () {
                            onLoadMore2 = false;
                          },
                        );
                      });
                    },
                    child: _supplier.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _supplier.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedindex = index;
                                    supplieralamatController.text = _supplier[index]["supplieralamat"];

                                    suppliernotelpController.text = _supplier[index]["suppliernoTelp"];
                                    suppliernamaController.text = _supplier[index]["suppliernamaSupplier"];
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                  height: 100,
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: selectedindex == index ? Colors.blue : Colors.blueGrey.shade50),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          widgetScreen.supplierText(Icon(PhosphorIcons.identificationCard, size: 20), _supplier[index]["suppliernamaSupplier"]),
                                          widgetScreen.supplierText(Icon(PhosphorIcons.phone, size: 20), _supplier[index]["suppliernoTelp"]),
                                          widgetScreen.supplierText(Icon(PhosphorIcons.mapPin, size: 20), _supplier[index]["supplieralamat"]),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Icon(PhosphorIcons.usersThree, size: 30),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox.shrink(),
                  ),
                ),
              ),
            ),
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
                if (namaBarangController.text.isEmpty || hargaController.text.isEmpty || stokController.text.isEmpty || suppliernamaController.text.isEmpty) {
                  setState(() {
                    warnings = true;
                  });
                } else {
                  setState(() {
                    warnings = false;
                  });
                  Random random = Random();
                  int randomNumber = random.nextInt(99999);
                  int randomNumber2 = random.nextInt(99999);
                  supplieridController.text = randomNumber.toString();

                  postBarang(
                    harga: double.parse(hargaController.text),
                    id: randomNumber,
                    id2: randomNumber2,
                    namaBarang: namaBarangController.text,
                    stok: int.parse(stokController.text),
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
