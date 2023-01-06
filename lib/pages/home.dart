// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables, unused_field, prefer_final_fields, unnecessary_null_comparison, avoid_print, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniproject/api/services.dart';
import 'package:miniproject/component/string.dart';
import 'package:miniproject/component/widget.dart';
import 'package:miniproject/model/BarangModel.dart';
import 'package:miniproject/model/SupplierModel.dart';
import 'package:miniproject/pages/addbarang.dart';
import 'package:miniproject/api/config.dart';
import 'package:miniproject/pages/addsupplier.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final field1Controller = TextEditingController();
  final field2Controller = TextEditingController();
  final field3Controller = TextEditingController();
  final supplieralamatController = TextEditingController();
  final supplieridController = TextEditingController();
  final suppliernamaController = TextEditingController();
  final suppliernotelpController = TextEditingController();

  final WidgetScreen widgetScreen = WidgetScreen();
  final TextScreen textScreen = TextScreen();

  int? selectedindexs;

  int id = 0;
  String profileName = "";
  String token = "";

  PageController? _pageController;
  int selectedIndex = 0;

  bool onLoadMore = false;
  int page = 1;
  BarangModel? _dataBarang;
  List _barang = [];
  bool isLoading = false;

  bool onLoadMore2 = false;
  int page2 = 1;
  SupplierModel? _dataSupplier;
  List _supplier = [];
  bool isLoading2 = false;

  bool warnings = false;

  @override
  void initState() {
    super.initState();

    getData();
    _pageController = PageController(initialPage: selectedIndex);
  }

  getData() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      id = (sharedPrefs.getInt('id') ?? 0);
      profileName = (sharedPrefs.getString('profileName') ?? "");
      token = (sharedPrefs.getString('token') ?? "");
    });
    await getBarang(1);
    await getSupplier(1);
  }

  getBarang(int pages) async {
    setState(() {
      onLoadMore = true;
    });
    final futurebarang = Config.getBarang(token, pages);

    if (pages == 1) {
      _barang.clear();
      setState(() {
        page = 1;
      });
    } else {
      //
    }
    await futurebarang.then((value) {
      if (value != null) {
        setState(() {
          _dataBarang = value;
        });
      }
    });
    if (_dataBarang == null || _dataBarang!.data == null) {
      if (!mounted) return;
      setState(() {
        onLoadMore = false;
        isLoading = true;
        return;
      });
    } else {
      setState(() {
        var data = _dataBarang!.data;
        for (var i = 0; i < data!.length; i++) {
          _barang.add(
            {
              "id": data[i].id,
              "namaBarang": data[i].namaBarang,
              "harga": data[i].harga,
              "stok": data[i].stok,
              "supplierid": data[i].supplier.id,
              "suppliernamaSupplier": data[i].supplier.namaSupplier,
              "suppliernoTelp": data[i].supplier.noTelp,
              "supplieralamat": data[i].supplier.alamat,
            },
          );
        }
      });
    }
    setState(() {
      onLoadMore = false;
      isLoading = true;
    });
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

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController!.animateToPage(selectedIndex, duration: Duration(milliseconds: 400), curve: Curves.easeOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          saveData("id", "");
                          saveData("profileName", "");
                          saveData("token", "");

                          Fluttertoast.showToast(
                            msg: textScreen.signout,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                            fontSize: 16,
                          );
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                      ),
                      selectedIndex == 0
                          ? widgetScreen.button(
                              textScreen.addbarang,
                              100,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddBarangPage()),
                              ),
                            )
                          : widgetScreen.button(
                              textScreen.addSupplier,
                              100,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddSupplier()),
                              ),
                            ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 15, bottom: 10),
                  child: Text(
                    textScreen.hi + " " + profileName,
                    style: GoogleFonts.didactGothic(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: PageView(
                      physics: NeverScrollableScrollPhysics(),
                      controller: _pageController,
                      children: [
                        Container(
                          width: size.width,
                          color: Colors.white,
                          child: ScrollConfiguration(
                            behavior: MyBehavior(),
                            child: RefreshLoadmore(
                              onRefresh: () => getBarang(1),
                              isLastPage: false,
                              onLoadmore: () async {
                                await Future.delayed(Duration(milliseconds: 500), () {
                                  setState(
                                    () {
                                      onLoadMore = true;
                                      page = page + 1;
                                    },
                                  );
                                  getBarang(page);
                                  setState(
                                    () {
                                      onLoadMore = false;
                                    },
                                  );
                                });
                              },
                              child: _barang.isNotEmpty
                                  ? ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _barang.length,
                                      itemBuilder: (context, index) {
                                        return Slidable(
                                          key: ValueKey(index),
                                          endActionPane: ActionPane(
                                            motion: ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    backgroundColor: Colors.transparent,
                                                    isScrollControlled: true,
                                                    builder: (BuildContext context) {
                                                      return StatefulBuilder(
                                                        builder: (BuildContext context, StateSetter setState) {
                                                          return SingleChildScrollView(
                                                            child: Container(
                                                              padding: MediaQuery.of(context).viewInsets,
                                                              height: size.height / 1.2,
                                                              width: size.width,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(30),
                                                                  topRight: Radius.circular(30),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.only(left: 15, right: 15),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    SizedBox(height: 20),
                                                                    widgetScreen.userInput(field1Controller, textScreen.namaBarang, TextInputType.text, false, false, "Text", () {}),
                                                                    widgetScreen.userInput(field2Controller, textScreen.harga, TextInputType.text, false, false, "Number", () {}),
                                                                    widgetScreen.userInput(field3Controller, textScreen.stok, TextInputType.text, false, false, "Number", () {}),
                                                                    SizedBox(height: 5),
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
                                                                                            selectedindexs = index;
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
                                                                                            border: Border.all(color: selectedindexs == index ? Colors.blue : Colors.blueGrey.shade50),
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
                                                                    warnings
                                                                        ? Text(
                                                                            textScreen.warning,
                                                                            style: GoogleFonts.didactGothic(color: Colors.red),
                                                                          )
                                                                        : SizedBox.shrink(),
                                                                    SizedBox(height: 5),
                                                                    widgetScreen.button(
                                                                      textScreen.submit,
                                                                      size.width,
                                                                      () async {
                                                                        if (field1Controller.text.isEmpty || field2Controller.text.isEmpty || field3Controller.text.isEmpty || suppliernamaController.text.isEmpty) {
                                                                          setState(() {
                                                                            warnings = true;
                                                                          });
                                                                        } else {
                                                                          setState(() {
                                                                            warnings = false;
                                                                          });
                                                                          updateBarang(
                                                                            harga: double.parse(field2Controller.text),
                                                                            id: _barang[index]["id"],
                                                                            namaBarang: field1Controller.text,
                                                                            stok: int.parse(field3Controller.text),
                                                                            alamat: supplieralamatController.text,
                                                                            namaSupplier: suppliernamaController.text,
                                                                            noTelp: suppliernotelpController.text,
                                                                            token: token,
                                                                          ).then(
                                                                            (response) async {
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                              var decoded = json.decode(response.body);

                                                                              if (response.statusCode == 200) {
                                                                                supplieralamatController.clear();
                                                                                suppliernamaController.clear();
                                                                                suppliernotelpController.clear();
                                                                                field1Controller.clear();
                                                                                field2Controller.clear();
                                                                                field3Controller.clear();
                                                                                Navigator.pop(context);
                                                                                getBarang(page);
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
                                                                    SizedBox(height: 20),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                foregroundColor: Colors.black,
                                                icon: Icons.update,
                                                label: textScreen.update,
                                              ),
                                              SlidableAction(
                                                onPressed: (context) {
                                                  deleteBarang(id: _barang[index]["id"], token: token).then(
                                                    (response) async {
                                                      var decoded = json.decode(response.body);

                                                      if (response.statusCode == 200) {
                                                        Fluttertoast.showToast(
                                                          msg: decoded["message"],
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.BOTTOM,
                                                          textColor: Colors.white,
                                                          fontSize: 16,
                                                        );
                                                        setState(() {
                                                          _barang.removeAt(index);
                                                        });
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
                                                },
                                                foregroundColor: Colors.black,
                                                icon: Icons.delete,
                                                label: textScreen.delete,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                                margin: EdgeInsets.fromLTRB(15, 5, 15, 0),
                                                height: 100,
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(14),
                                                  border: Border.all(color: Colors.blueGrey.shade50),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              _barang[index]["id"].toString(),
                                                              style: GoogleFonts.didactGothic(color: Colors.black),
                                                            ),
                                                            SizedBox(height: 5),
                                                            Text(
                                                              _barang[index]["namaBarang"],
                                                              style: GoogleFonts.didactGothic(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                            ),
                                                            SizedBox(height: 15),
                                                            Text(
                                                              "Stock: " + _barang[index]["stok"].toString(),
                                                              style: GoogleFonts.didactGothic(color: Colors.black),
                                                            ),
                                                          ],
                                                        ),
                                                        Text(
                                                          _barang[index]["harga"].toString(),
                                                          style: GoogleFonts.didactGothic(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 26),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.fromLTRB(25, 0, 25, 10),
                                                height: 85,
                                                width: size.width,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.only(
                                                    bottomLeft: Radius.circular(10),
                                                    bottomRight: Radius.circular(10),
                                                  ),
                                                  color: Colors.blueGrey.shade50,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            widgetScreen.supplierText(Icon(PhosphorIcons.identificationCard, size: 20), _barang[index]["suppliernamaSupplier"]),
                                                            widgetScreen.supplierText(Icon(PhosphorIcons.phone, size: 20), _barang[index]["suppliernoTelp"]),
                                                            widgetScreen.supplierText(Icon(PhosphorIcons.mapPin, size: 20), _barang[index]["supplieralamat"]),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(right: 15),
                                                          child: Icon(PhosphorIcons.usersThree, size: 50),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ),
                        ),

                        //Page Supplier
                        Container(
                          width: size.width,
                          color: Colors.white,
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
                                        return Slidable(
                                          key: ValueKey(index),
                                          endActionPane: ActionPane(
                                            motion: ScrollMotion(),
                                            children: [
                                              SlidableAction(
                                                onPressed: (context) {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    backgroundColor: Colors.transparent,
                                                    isScrollControlled: true,
                                                    builder: (BuildContext context) {
                                                      return StatefulBuilder(
                                                        builder: (BuildContext context, StateSetter setState) {
                                                          return SingleChildScrollView(
                                                            child: Container(
                                                              padding: MediaQuery.of(context).viewInsets,
                                                              width: size.width,
                                                              decoration: BoxDecoration(
                                                                color: Colors.white,
                                                                borderRadius: BorderRadius.only(
                                                                  topLeft: Radius.circular(30),
                                                                  topRight: Radius.circular(30),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets.only(left: 15, right: 15),
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    SizedBox(height: 20),
                                                                    widgetScreen.userInput(field1Controller, textScreen.suppliername, TextInputType.text, false, false, "Text", () {}),
                                                                    widgetScreen.userInput(field2Controller, textScreen.supplieralamat, TextInputType.text, false, false, "Text", () {}),
                                                                    widgetScreen.userInput(field3Controller, textScreen.suppliernamenoTelp, TextInputType.text, false, false, "Text", () {}),
                                                                    SizedBox(height: 5),
                                                                    warnings
                                                                        ? Text(
                                                                            textScreen.warning,
                                                                            style: GoogleFonts.didactGothic(color: Colors.red),
                                                                          )
                                                                        : SizedBox.shrink(),
                                                                    SizedBox(height: 5),
                                                                    widgetScreen.button(
                                                                      textScreen.submit,
                                                                      size.width,
                                                                      () async {
                                                                        if (field1Controller.text.isEmpty || field2Controller.text.isEmpty || field3Controller.text.isEmpty) {
                                                                          setState(() {
                                                                            warnings = true;
                                                                          });
                                                                        } else {
                                                                          setState(() {
                                                                            warnings = false;
                                                                          });
                                                                          updateSupplier(
                                                                            id: _supplier[index]["supplierid"],
                                                                            alamat: field2Controller.text,
                                                                            namaSupplier: field1Controller.text,
                                                                            noTelp: field3Controller.text,
                                                                            token: token,
                                                                          ).then(
                                                                            (response) async {
                                                                              FocusManager.instance.primaryFocus?.unfocus();
                                                                              var decoded = json.decode(response.body);

                                                                              if (response.statusCode == 200) {
                                                                                field1Controller.clear();
                                                                                field2Controller.clear();
                                                                                field3Controller.clear();
                                                                                Navigator.pop(context);
                                                                                getSupplier(page2);
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
                                                                    SizedBox(height: 20),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                                foregroundColor: Colors.black,
                                                icon: Icons.update,
                                                label: textScreen.update,
                                              ),
                                              SlidableAction(
                                                onPressed: (context) {
                                                  deleteSupplier(id: _supplier[index]["supplierid"], token: token).then(
                                                    (response) async {
                                                      var decoded = json.decode(response.body);

                                                      if (response.statusCode == 200) {
                                                        Fluttertoast.showToast(
                                                          msg: decoded["message"],
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.BOTTOM,
                                                          textColor: Colors.white,
                                                          fontSize: 16,
                                                        );
                                                        setState(() {
                                                          _supplier.removeAt(index);
                                                        });
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
                                                },
                                                foregroundColor: Colors.black,
                                                icon: Icons.delete,
                                                label: textScreen.delete,
                                              ),
                                            ],
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                            margin: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                            height: 100,
                                            width: size.width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(14),
                                              border: Border.all(color: Colors.blueGrey.shade50),
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
                                                  child: Icon(PhosphorIcons.usersThree, size: 50),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SlidingClippedNavBar(
          backgroundColor: Colors.black,
          onButtonPressed: (index) {
            setState(() {
              selectedIndex = index;
            });
            _pageController!.animateToPage(selectedIndex, duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
          },
          iconSize: 30,
          activeColor: Colors.white,
          inactiveColor: Colors.grey,
          selectedIndex: selectedIndex,
          barItems: [
            BarItem(
              icon: PhosphorIcons.cube,
              title: textScreen.barang,
            ),
            BarItem(
              icon: PhosphorIcons.usersThree,
              title: textScreen.supplier,
            ),
          ],
        ),
      ),
    );
  }
}
