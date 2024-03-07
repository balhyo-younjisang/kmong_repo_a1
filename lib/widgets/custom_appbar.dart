import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthAppBar extends StatelessWidget {
  const AuthAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 210),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 250, 250, 210),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const SizedBox(
            width: 10,
          ),
          const Text(
            '문자 발송',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          InkWell(
            child: const Text("로그아웃"),
            onTap: () async {
              var storage = const FlutterSecureStorage();
              await storage.delete(key: "token");

              if (!context.mounted) return;
              Navigator.pushNamed(context, "/");
            },
          )
        ]),
      ),
    );
  }
}
