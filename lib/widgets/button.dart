import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final void Function() handler;
  final Color backgroundColor;
  final Color? fontColor;

  const ButtonWidget(
      {super.key,
      required this.text,
      required this.handler,
      required this.backgroundColor,
      this.fontColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: handler,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
        ),
        padding: const EdgeInsets.all(10),
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: fontColor ?? Colors.black),
        )),
      ),
    );
  }
}
