import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:kmong_repo_a1/apis/auth.dart';
import 'package:kmong_repo_a1/widgets/auth_appbar.dart';
import 'package:kmong_repo_a1/widgets/button.dart';
import 'package:kmong_repo_a1/widgets/input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final backgroundColor = const Color.fromARGB(255, 250, 250, 210);

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: "token");
      // ignore: unnecessary_null_comparison
      if (context.mounted && token != null) {
        Navigator.pushNamed(context, "/home");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: CustomAppBar(),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      InputWidget(
                          text: "전화번호 입력",
                          isSecure: false,
                          controller: phoneNumberController),
                      InputWidget(
                          text: "비밀번호 입력",
                          isSecure: true,
                          controller: passwordController)
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  width: 300,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonWidget(
                        text: "로그인",
                        handler: () async {
                          String phoneNumber = phoneNumberController.text;
                          String password = passwordController.text;

                          dynamic res =
                              await postSignInUser(phoneNumber, password);

                          if (!context.mounted) return;

                          if (res['code'] == 200) {
                            if (!context.mounted) return;
                            Navigator.pushNamed(context, "/home");
                          } else {
                            Get.snackbar("로그인 실패", res['message']);
                          }
                        },
                        backgroundColor: Colors.yellow,
                      ),
                      ButtonWidget(
                        text: "회원가입",
                        fontColor: Colors.white,
                        handler: () {
                          Navigator.pushNamed(context, "/join");
                        },
                        backgroundColor:
                            const Color.fromARGB(255, 105, 105, 105),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text("문의 : 02-546-1113")
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}
