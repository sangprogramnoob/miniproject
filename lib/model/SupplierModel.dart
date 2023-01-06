// To parse this JSON data, do
//
//     final supplierModel = supplierModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

SupplierModel supplierModelFromJson(String str) => SupplierModel.fromJson(json.decode(str));

String supplierModelToJson(SupplierModel data) => json.encode(data.toJson());

class SupplierModel {
  SupplierModel({
    required this.data,
    required this.message,
    required this.status,
    required this.limit,
    required this.page,
    required this.totalPage,
    required this.totalRecord,
  });

  List<Datum> data;
  String message;
  String status;
  int limit;
  int page;
  int totalPage;
  int totalRecord;

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
        status: json["status"],
        limit: json["limit"],
        page: json["page"],
        totalPage: json["total_page"],
        totalRecord: json["total_record"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "message": message,
        "status": status,
        "limit": limit,
        "page": page,
        "total_page": totalPage,
        "total_record": totalRecord,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.namaSupplier,
    required this.noTelp,
    required this.alamat,
  });

  int id;
  String namaSupplier;
  String noTelp;
  String alamat;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        namaSupplier: json["namaSupplier"],
        noTelp: json["noTelp"],
        alamat: json["alamat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "namaSupplier": namaSupplier,
        "noTelp": noTelp,
        "alamat": alamat,
      };
}
