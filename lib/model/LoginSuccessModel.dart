// To parse this JSON data, do
//
//     final loginSuccesModel = loginSuccesModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

LoginSuccesModel loginSuccesModelFromJson(String str) => LoginSuccesModel.fromJson(json.decode(str));

String loginSuccesModelToJson(LoginSuccesModel data) => json.encode(data.toJson());

class LoginSuccesModel {
  LoginSuccesModel({
    required this.data,
    required this.message,
    required this.status,
  });

  Data data;
  String message;
  String status;

  factory LoginSuccesModel.fromJson(Map<String, dynamic> json) => LoginSuccesModel(
        data: Data.fromJson(json["data"]),
        message: json["message"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "message": message,
        "status": status,
      };
}

class Data {
  Data({
    required this.id,
    required this.username,
    required this.profileName,
    required this.token,
  });

  int id;
  String username;
  String profileName;
  String token;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        username: json["username"],
        profileName: json["profileName"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "profileName": profileName,
        "token": token,
      };
}
