import 'package:flutter/material.dart';
import 'package:kmong_repo_a1/apis/user.dart';
import 'package:kmong_repo_a1/widgets/button.dart';
import 'package:kmong_repo_a1/widgets/custom_appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic userData = "총 발송량 : 0, 일일 최대 발송량: 0";
  dynamic groupList = [];
  final backgroundColor = const Color.fromARGB(255, 250, 250, 210);

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((_) async {
      userData = await getUserData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AuthAppBar(),
        ),
        body: Column(
          children: [
            Container(
                alignment: Alignment.center,
                height: 26,
                child: Text(
                  userData['data']
                      .toString()
                      .replaceAll("{", '')
                      .replaceAll("}", ''),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                )),
            SizedBox(
              width: 300,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWidget(
                      text: "그룹 관리",
                      handler: () {
                        Navigator.pushNamed(context, "/group");
                      },
                      backgroundColor: Colors.yellow),
                  const SizedBox(
                    width: 30,
                  ),
                  ButtonWidget(
                      text: "발송 시작",
                      fontColor: Colors.white,
                      handler: () {
                        Navigator.pushNamed(context, "/group");
                      },
                      backgroundColor: const Color.fromARGB(255, 105, 105, 105))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
