import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getTeachersData() async {
  try {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");

    http.Response response = await http.get(
        Uri.parse(
            "https://port-0-kmong-repo-a1-server-dc9c2nlt1e5hi9.sel5.cloudtype.app/api/v1/admin/manage"),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 401) {
      return {"message": "권한이 필요합니다", "code": 401};
    }
    dynamic jsonResponse = jsonDecode(response.body);

    return {
      "message": "데이터 가져오기 성공",
      "code": 200,
      "data": jsonResponse['response']
    };
  } catch (e) {
    return {"message": "오류가 발생했습니다", "code": 500};
  }
}

Future<Map<String, dynamic>> patchUserMaxSend(
    String phoneNumber, String value) async {
  try {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");

    http.Response response = await http.patch(
        Uri.parse(
            "https://port-0-kmong-repo-a1-server-dc9c2nlt1e5hi9.sel5.cloudtype.app/api/v1/admin/edit"),
        headers: {"Authorization": "Bearer $token"},
        body: {'phoneNumber': phoneNumber, "maxSend": value});

    if (response.statusCode == 401) {
      return {"message": "권한이 필요합니다", "code": 401};
    } else if (response.statusCode == 200) {
      return {
        "message": "데이터 수정 성공",
        "code": 200,
      };
    }

    return {
      "message": "서버 오류",
      "code": response.statusCode,
    };
  } catch (e) {
    return {"message": "오류가 발생했습니다", "code": 400};
  }
}
