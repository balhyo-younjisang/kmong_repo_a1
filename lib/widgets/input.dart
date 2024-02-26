import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String text;
  final bool isSecure;
  final TextEditingController controller;

  const InputWidget(
      {super.key,
      required this.text,
      required this.isSecure,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          obscureText: isSecure,
          controller: controller,
          decoration: InputDecoration(hintText: text),
        )
      ],
    );
  }
}
