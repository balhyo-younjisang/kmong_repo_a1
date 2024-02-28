import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getUserData() async {
  try {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");
    debugPrint(token);

    http.Response admin_response = await http.get(
        Uri.parse(
            "https://port-0-kmong-repo-a1-server-dc9c2nlt1e5hi9.sel5.cloudtype.app/api/v1/admin/manage"),
        headers: {"Authorization": "Bearer $token"});

    if (admin_response.statusCode == 200) {
      return {"message": "관리자입니다", "code": 200, "admin": true, "data": true};
    }

    http.Response response = await http.get(
        Uri.parse(
            "https://port-0-kmong-repo-a1-server-dc9c2nlt1e5hi9.sel5.cloudtype.app/api/v1/users/my"),
        headers: {"Authorization": "Bearer $token"});
    dynamic jsonResponse = jsonDecode(response.body);

    return {
      "message": "데이터 가져오기 성공",
      "code": 200,
      "data": jsonResponse['data']
    };
  } catch (e) {
    return {"message": "에러가 발생했어요", "code": 500};
  }
}

// ignore: non_constant_identifier_names
Future<Map<String, dynamic>> editUserData(int send_count) async {
  try {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");
    await http.patch(
        Uri.parse(
            "https://port-0-kmong-repo-a1-server-dc9c2nlt1e5hi9.sel5.cloudtype.app/api/v1/users/edit"),
        headers: {"Authorization": "Bearer $token"},
        body: {"send_count": send_count.toString()});

    return {
      "message": "데이터 수정 성공",
      "code": 200,
    };
  } catch (e) {
    return {"message": "에러가 발생했어요", "code": 500};
  }
}
