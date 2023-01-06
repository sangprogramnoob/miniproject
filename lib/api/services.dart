// ignore_for_file: file_names, avoid_print, prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:miniproject/component/string.dart';

Future<http.Response> postRegister({required String password, required String profileName, required String username}) {
  return http.post(
    Uri.http(TextScreen().urlbase, TextScreen().urlregister),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'password': password,
      'profileName': profileName,
      'username': username,
    }),
  );
}

Future<http.Response> postLogin({required String password, required String username}) {
  return http.post(
    Uri.http(TextScreen().urlbase, TextScreen().urlLogin),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'password': password,
      'username': username,
    }),
  );
}

Future<http.Response> postBarang({required double harga, required int id, required int id2, required String namaBarang, required int stok, required String alamat, required String namaSupplier, required String noTelp, required String token}) {
  var bodyJson = {
    'harga': harga,
    'namaBarang': namaBarang,
    'stok': stok,
    'supplier': {"alamat": alamat, "namaSupplier": namaSupplier, "noTelp": noTelp}
  };
  Map<String, String> headers = {
    "content-type": "application/json",
    "accept": "application/json",
    'Authorization': 'Bearer $token',
  };

  return http.post(
    Uri.http(TextScreen().urlbase, TextScreen().urlPostBarang),
    headers: headers,
    body: jsonEncode(bodyJson),
  );
}

Future<http.Response> postSupplier({required String alamat, required String namaSupplier, required String noTelp, required String token}) {
  var bodyJson = {
    "alamat": alamat,
    "namaSupplier": namaSupplier,
    "noTelp": noTelp,
  };
  Map<String, String> headers = {
    "content-type": "application/json",
    "accept": "application/json",
    'Authorization': 'Bearer $token',
  };

  return http.post(
    Uri.http(TextScreen().urlbase, TextScreen().urlPostSupplier),
    headers: headers,
    body: jsonEncode(bodyJson),
  );
}

Future<http.Response> deleteBarang({required int id, required String token}) {
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
  };
  return http.delete(
    Uri.http(TextScreen().urlbase, TextScreen().urlDeleteBarang + "/$id"),
    headers: headers,
  );
}

Future<http.Response> deleteSupplier({required int id, required String token}) {
  Map<String, String> headers = {
    'Authorization': 'Bearer $token',
  };
  return http.delete(
    Uri.http(TextScreen().urlbase, TextScreen().urlDeleteSupplier + "/$id"),
    headers: headers,
  );
}

Future<http.Response> updateBarang({required double harga, required int id, required String namaBarang, required int stok, required String alamat, required String namaSupplier, required String noTelp, required String token}) {
  var bodyJson = {
    'harga': harga,
    'namaBarang': namaBarang,
    'stok': stok,
    'supplier': {
      "alamat": alamat,
      "namaSupplier": namaSupplier,
      "noTelp": noTelp,
    }
  };

  Map<String, String> headers = {
    "content-type": "application/json",
    "accept": "application/json",
    'Authorization': 'Bearer $token',
  };

  print(bodyJson);
  print(id);
  return http.put(
    Uri.http(TextScreen().urlbase, TextScreen().urlupdateBarang + "/$id"),
    headers: headers,
    body: jsonEncode(bodyJson),
  );
}

Future<http.Response> updateSupplier({required int id, required String alamat, required String namaSupplier, required String noTelp, required String token}) {
  var bodyJson = {
    "alamat": alamat,
    "namaSupplier": namaSupplier,
    "noTelp": noTelp,
  };
  Map<String, String> headers = {
    "content-type": "application/json",
    "accept": "application/json",
    'Authorization': 'Bearer $token',
  };
  print(bodyJson);
  return http.put(
    Uri.http(TextScreen().urlbase, TextScreen().urlupdateSupplier + "/$id"),
    headers: headers,
    body: jsonEncode(bodyJson),
  );
}
