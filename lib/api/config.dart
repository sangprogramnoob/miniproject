// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';

import 'package:http/http.dart';
import 'package:miniproject/component/string.dart';
import 'package:miniproject/model/BarangModel.dart';
import 'package:miniproject/model/SupplierModel.dart';

class Config {
  static Future<BarangModel> getBarang(String token, int page) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    var queryParameters = {
      'limit': "20",
      'offset': "$page",
    };
    final response = await get(Uri.http(TextScreen().urlbase, TextScreen().urlBarang, queryParameters), headers: headers);

    final parsed = json.decode(response.body);
    var data = BarangModel.fromJson(parsed);
    return data;
  }

  static Future<SupplierModel> getSupplier(String token, int page) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };
    var queryParameters = {
      'limit': "20",
      'offset': "$page",
    };
    final response = await get(Uri.http(TextScreen().urlbase, TextScreen().urlSupplier, queryParameters), headers: headers);

    final parsed = json.decode(response.body);
    var data = SupplierModel.fromJson(parsed);
    return data;
  }
}
