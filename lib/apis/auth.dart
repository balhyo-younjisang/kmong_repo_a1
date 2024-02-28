import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> postCreateUser(
    String phoneNumber, String password, String confirmPassword) async {
  if (password.compareTo(confirmPassword) == -1) {
    return {"message": "비밀번호가 일치하지 않습니다", "code": 400};
  }

  try {
    http.Response response = await http.post(
        Uri.parse(
            "https://port-0-kmong-repo-a1-server-dc9c2nlt1e5hi9.sel5.cloudtype.app/api/v1/users/signup"),
        body: {
          "phoneNumber": phoneNumber,
          "password": password,
          "confirmPassword": confirmPassword
        });

    if (response.statusCode == 201) {
      return {"message": "회원가입 성공", "code": 201};
    } else {
      dynamic jsonResponse = jsonDecode(response.body);
      return {"message": jsonResponse['message'], "code": jsonResponse['code']};
    }
  } catch (e) {
    debugPrint(e.toString());
    return {"message": "에러가 발생했어요", "code": 500};
  }
}

Future<Map<String, dynamic>> postSignInUser(
    String phoneNumber, String password) async {
  try {
    http.Response response = await http.post(
        Uri.parse(
            "https://port-0-kmong-repo-a1-server-dc9c2nlt1e5hi9.sel5.cloudtype.app/api/v1/users/signin"),
        body: {"phoneNumber": phoneNumber, "password": password});
    dynamic jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      debugPrint(jsonResponse.toString());
      const storage = FlutterSecureStorage();
      await storage.write(key: "token", value: jsonResponse['data']);

      return {
        "message": "로그인 성공",
        "code": 200,
      };
    } else {
      return {"message": jsonResponse['message'], "code": jsonResponse['code']};
    }
  } catch (e) {
    debugPrint(e.toString());
    return {"message": "에러가 발생했어요", "code": 500};
  }
}
