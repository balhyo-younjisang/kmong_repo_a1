import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kmong_repo_a1/apis/auth.dart';
import 'package:kmong_repo_a1/widgets/auth_appbar.dart';
import 'package:kmong_repo_a1/widgets/button.dart';
import 'package:kmong_repo_a1/widgets/input.dart';

class JoinPage extends StatelessWidget {
  JoinPage({super.key});
  final backgroundColor = const Color.fromARGB(255, 250, 250, 210);

  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60),
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
                          controller: passwordController),
                      InputWidget(
                          text: "비밀번호 확인",
                          isSecure: true,
                          controller: confirmPasswordController)
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
                        text: "회원가입",
                        handler: () async {
                          String phoneNumber = phoneNumberController.text;
                          String password = passwordController.text;
                          String confirmPassword =
                              confirmPasswordController.text;

                          dynamic res = await postCreateUser(
                              phoneNumber, password, confirmPassword);

                          if (!context.mounted) return;
                          if (res['code'] == 201) {
                            Navigator.pushNamed(context, "/");
                          } else {
                            Get.snackbar("회원가입 실패", res['message']);
                          }
                        },
                        backgroundColor: Colors.yellow,
                      ),
                      ButtonWidget(
                        text: "로그인",
                        fontColor: Colors.white,
                        handler: () {
                          Navigator.pushNamed(context, "/");
                        },
                        backgroundColor:
                            const Color.fromARGB(255, 105, 105, 105),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
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
