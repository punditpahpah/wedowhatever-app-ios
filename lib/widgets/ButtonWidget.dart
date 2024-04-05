
// import 'package:flutter/material.dart';
// import 'package:whatever_ios/theme/colors.dart';

// import 'CustomTextWidget.dart';

// class ButtonWidget extends StatefulWidget {
//   const ButtonWidget({
//     required this.text,
//     Key? key,
//     required this.size,
//   }) : super(key: key);

//   final Size size;
//   final String text;

//   @override
//   _ButtonWidgetState createState() => _ButtonWidgetState();
// }

// class _ButtonWidgetState extends State<ButtonWidget> {
//   var istap = false;
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           if (istap) {
//             istap = false;
//           } else {
//             istap = true;
//           }
//         });
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: widget.size.height * 0.008),
//         height: widget.size.height * 0.08,
//         width: widget.size.width * 0.85,
//         decoration: BoxDecoration(
//           color: istap ? null : CustomColors.ButtonColour,
//           border: istap
//               ? Border.all(color: CustomColors.ButtonColour, width: 1)
//               : null,
//           borderRadius: BorderRadius.all(Radius.circular(15)),
//         ),
//         child: Center(
//             child: CustomTextWidget(
//           textalign: TextAlign.center,
//           color: istap ? CustomColors.ButtonColour : CustomColors.WhiteColour,
//           fontsize: 0.025,
//           isbold: true,
//           text: widget.text,
//         )),
//       ),
//     );
//   }
// }
