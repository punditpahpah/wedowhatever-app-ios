import 'package:flutter/material.dart';
import 'package:whatever_ios/theme/colors.dart';

class TextFieldWidget extends StatefulWidget {
  TextFieldWidget({required this.labeltext, required this.obscure,required this.Tcontroller,required this.lines, required this.enabled, Key? key})
      : super(key: key);
  String labeltext;
  bool obscure,enabled;
  TextEditingController Tcontroller;
  int lines;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool focus = false;
  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          setState(() {
            focus = true;
          });
        } else {
          setState(() {
            focus = false;
          });
        }
      },
      child: TextFormField(
        enabled: widget.enabled,
        maxLines: widget.lines,
        controller: widget.Tcontroller,
        obscureText: widget.obscure,
        decoration: new InputDecoration(
            contentPadding:
                new EdgeInsets.symmetric(vertical: -5.0, horizontal: 10.0),
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.DarkBlueColour, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            labelText: widget.labeltext,
            labelStyle: TextStyle(
                color: focus ? CustomColors.DarkBlueColour : Colors.grey)),
        validator: (String? value) {
          return (value != null && value.contains('@'))
              ? 'Do not use the @ char.'
              : null;
        },
      ),
    );
  }
}
