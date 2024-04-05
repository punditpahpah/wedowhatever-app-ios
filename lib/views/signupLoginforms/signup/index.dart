import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatever_ios/routes/app_pages.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/signupLoginforms/login/index.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:whatever_ios/widgets/SmallButtonWidget.dart';
import 'package:whatever_ios/widgets/TextFormFieldWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:math';
import 'dart:convert';

class SignUpForms extends StatefulWidget {
  const SignUpForms({Key? key}) : super(key: key);

  @override
  _SignUpFormsState createState() => _SignUpFormsState();
}

class _SignUpFormsState extends State<SignUpForms> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  int emailValue = 0;
  Random random = new Random();

  final _NameController = TextEditingController();
  final _EmailController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _Last_NameController = TextEditingController();
  final _secondPassword = TextEditingController();

  // void validate() {
  //   if (formkey.currentState!.validate()) {
  //     var _user_email = _EmailController.text;
  //     var _user_password = _PasswordController.text;
  //     var _user_name = _NameController.text;
  //     var _last_name = _Last_NameController.text;

  //     Register(_user_name, _last_name, _user_email, _user_password);
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Please fill the fields",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.CENTER,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //   }
  // }

  Future SendEmail(String _user_firstname, String _user_lastname,
      String _user_email, String _user_password) async {
    emailValue = random.nextInt(9999) + 1111;
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(Constants.base_url + "send_email.php");
    var response = await http.post(url, body: {
      "email": _user_email,
      "pin": emailValue.toString(),
      "from": "active",
      "auth_key": Constants.auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Email Sent");
      await dialog.hide();
      CreateAlertDialog(context, _user_firstname, _user_lastname, _user_email, _user_password);
    } else if (code == "0") {
      ShowResponse("Email Not Sent");
    } else if (code == "2") {
      ShowResponse("Email does not exist");
    } else {
      ShowResponse(response.body.toString());
    }
    await dialog.hide();
  }

  //Register Function Start
  Future Register(String _user_firstname, String _user_lastname,
      String _user_email, String _user_password) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(Constants.base_url + "register.php");
    var response = await http.post(url, body: {
      "username": _user_email,
      "password": _user_password,
      "email": _user_email,
      "first_name": _user_firstname,
      "last_name": _user_lastname,
      "ip_address": "1.1.1.1",
      "gender": "male",
      "last_user_agent": "iOS",
      "last_ua_version": "1.1.1.1",
      "last_os": "iOS",
      "last_device": "iOS",
      "auth_key": Constants.auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Registered Successfully");
      await dialog.hide();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginForms()),
      );
    } else if (code == "0") {
      ShowResponse("Email already registered");
    } else {
      ShowResponse(response.body.toString());
    }
    await dialog.hide();
  }

  //Register Function End
  //Show Response Functions Start
  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //Show Response Function End

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: CustomTextWidget(
            color: Colors.white,
            fontsize: 0.025,
            isbold: true,
            text: 'Sign Up',
            textalign: TextAlign.start,
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Form(
            key: formkey,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/whatever_banner.jpg',
                ),
                SizedBox(
                  height: 25,
                ),
                TextFieldWidget(
                  Tcontroller: _NameController,
                  labeltext: 'First Name',
                  obscure: false,
                  lines: 1,
                  enabled: true,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  Tcontroller: _Last_NameController,
                  labeltext: 'Last Name',
                  obscure: false,
                  lines: 1,
                  enabled: true,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  Tcontroller: _EmailController,
                  labeltext: 'Email',
                  obscure: false,
                  lines: 1,
                  enabled: true,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  Tcontroller: _PasswordController,
                  labeltext: 'Password',
                  obscure: true,
                  lines: 1,
                  enabled: true,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFieldWidget(
                  Tcontroller: _secondPassword,
                  labeltext: 'Confirm Password',
                  obscure: true,
                  lines: 1,
                  enabled: true,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Checkbox(
                        //value: checkBoxValue,
                        activeColor: CustomColors.DarkBlueColour,
                        onChanged: (bool? value) {}, value: true,
                        //     onChanged:(bool newValue){
                        //   setState(() {
                        //     checkBoxValue = newValue;
                        //   });
                        //  Text('Remember me');
                        //     }
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: CustomTextWidget(
                          text:
                              'By clicking Sign Up to wedowhatever.com, that you are over the age of 13 years old',
                          fontsize: 0.02,
                          isbold: true,
                          color: Colors.grey,
                          textalign: TextAlign.start),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                CustomTextWidget(
                    text:
                        'Agree to our Terms and Conditions and that you have read our Data Policy, including our cookie Use. Tap to see.',
                    fontsize: 0.02,
                    isbold: true,
                    color: Colors.grey,
                    textalign: TextAlign.start),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    var _user_email = _EmailController.text;
                    var _user_password = _PasswordController.text;
                    var _user_name = _NameController.text;
                    var _last_name = _Last_NameController.text;
                    var _c_pass = _secondPassword.text;
                    if (_user_name.length < 3) {
                      ShowResponse(
                          "Please enter 3 atlest chatacters long First Name");
                    } else if (_last_name.length < 3) {
                      ShowResponse(
                          "Please enter 3 atlest chatacters long Last Name");
                    } else if (_user_email == "" ||
                        !_user_email.contains("@") ||
                        !_user_email.contains(".")) {
                      ShowResponse("Please enter valid email");
                    } else if (_user_password.length < 6) {
                      ShowResponse(
                          "Please enter 6 at lest chatacters long password");
                    } else if (_user_password != _c_pass) {
                      ShowResponse("Password does not match");
                    } else {
                      SendEmail(_user_name, _last_name, _user_email, _user_password);
                    }
                  },
                  child: SmalllButtonWidget(
                      fontsize: 0.025,
                      height: 0.06,
                      text: 'REGISTER',
                      width: 0.9,
                      size: size),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    CustomTextWidget(
                        text: 'Already have an account?',
                        fontsize: 0.03,
                        isbold: false,
                        color: Colors.black,
                        textalign: TextAlign.center),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SmalllButtonWidget(
                          fontsize: 0.025,
                          height: 0.06,
                          text: 'LOGIN',
                          width: 0.9,
                          size: size),
                    ),  
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  CreateAlertDialog(BuildContext context, String _user_firstname, String _user_lastname,
      String _user_email, String _user_password) {
    TextEditingController room_name_controller = new TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Code sent to $_user_email"),
            content: TextField(
              keyboardType: TextInputType.number,
              controller: room_name_controller,
            ),
            actions: [
              MaterialButton(
                elevation: 5.0,
                child: Text("Resend Email"),
                onPressed: () {
                  Navigator.pop(context);
                  SendEmail(_user_firstname,_user_lastname,_user_email,_user_password);
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text("Continue"),
                onPressed: () {
                  if (room_name_controller.text.toString() ==
                      emailValue.toString()) {
                    Navigator.of(context, rootNavigator: true).pop();
                    Register(
                          _user_firstname, _user_lastname, _user_email, _user_password);
                    
                  } else {
                    Fluttertoast.showToast(
                        msg: "Invalid Code",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        backgroundColor: CustomColors.DarkBlueColour,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                },
              ),
            ],
          );
        });
  }
}
