import 'package:flutter/material.dart';
import 'package:whatever_ios/theme/colors.dart';

import 'CustomTextWidget.dart';

class SocialBtnWidget extends StatelessWidget {
  SocialBtnWidget({
    required this.fontsize,
    required this.height,
    required this.text,
    required this.width,
    required this.link,
    required this.color,
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;
  final String text,link, color;
  double height, width, fontsize;
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: size.height * height,
      width: size.width * width,
      decoration: BoxDecoration(
          color: Color(int.parse(color)),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundImage: AssetImage(link),
            backgroundColor: Colors.transparent,
          ),
          SizedBox(width: 5,),
          CustomTextWidget(
            color: Colors.white,
            fontsize: fontsize,
            isbold: false,
            text: text,
            textalign: TextAlign.center,
          ),
        ],
      )),
    );
  }
}
