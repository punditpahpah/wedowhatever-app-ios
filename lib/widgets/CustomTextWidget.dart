import 'package:flutter/material.dart';

class CustomTextWidget extends StatelessWidget {
  CustomTextWidget({
    required this.text,
    required this.fontsize,
    required this.isbold,
    required this.color,
    required this.textalign,
    Key? key,
  }) : super(key: key);

  final String text;
  final double fontsize;
  final bool isbold;
  final Color color;
  final TextAlign textalign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: MediaQuery.of(context).size.height * fontsize,
        fontWeight: isbold ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign:textalign,
    );
  }
}
