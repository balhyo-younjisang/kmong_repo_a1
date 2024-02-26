import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getUserData() async {
  try {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: "token");

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
