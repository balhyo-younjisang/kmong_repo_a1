import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 210),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 250, 250, 210),
        ),
        child:
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '문자 발송',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ]),
      ),
    );
  }
}
