import 'package:flutter/material.dart';
import 'package:whatever_ios/theme/colors.dart';

import 'CustomTextWidget.dart';

class SmalllButtonWidget extends StatelessWidget {
  SmalllButtonWidget({
    required this.fontsize,
    required this.height,
    required this.text,
    required this.width,
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;
  final String text;
  double height, width, fontsize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * height,
      width: size.width * width,
      decoration: BoxDecoration(
          color: CustomColors.DarkBlueColour,
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Center(
          child: CustomTextWidget(
        color: Colors.white,
        fontsize: fontsize,
        isbold: false,
        text: text,
        textalign: TextAlign.center,
      )),
    );
  }
}
