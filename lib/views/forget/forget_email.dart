import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatever_ios/routes/app_pages.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/signupLoginforms/signup/index.dart';
import 'package:whatever_ios/views/social_logins/social_logins.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:whatever_ios/widgets/SmallButtonWidget.dart';
import 'package:whatever_ios/widgets/TextFormFieldWidget.dart';
import 'package:http/http.dart' as http;
import 'package:whatever_ios/widgets/social_btn.dart';
import 'dart:math';

class ForgetEmail extends StatefulWidget {
  const ForgetEmail({Key? key}) : super(key: key);

  @override
  _ForgetEmailState createState() => _ForgetEmailState();
}

class _ForgetEmailState extends State<ForgetEmail> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  int emailValue = 0;
  Random random = new Random();

  @override
  void initState() {
    super.initState();
    getStringValuesSF();
  }

  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var is_logged_in = prefs.getString('is_logged_in');
    setState(() {});

    if (is_logged_in.toString() == "yes") {
      Get.toNamed(
        AppRoutes.HOME,
      );
    }
  }

  final _EmailController = TextEditingController();
  final _PasswordController = TextEditingController();
  final _CPasswordController = TextEditingController();

  //Login Function Start
  Future Reset(String _user_email, String _user_password) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(Constants.base_url + "reset.php");
    var response = await http.post(url, body: {
      "email": _user_email,
      "password": _user_password,
      "auth_key": Constants.auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Password Reset Successfully");
      setState(() {
        _EmailController.text = "";
        _PasswordController.text = "";
        _CPasswordController.text = "";
        pass_enabled = false;
        email_enabled = true;
        btn_text = "CHECK EMAIL";
      });
    } else if (code == "0") {
      ShowResponse("Password Did Not Reset");
    } else {
      ShowResponse(response.body.toString());
    }
    await dialog.hide();
  }

  Future SendEmail(String _user_email) async {
    emailValue = random.nextInt(9999) + 1111;
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(Constants.base_url + "send_email.php");
    var response = await http.post(url, body: {
      "email": _user_email,
      "pin": emailValue.toString(),
      "from": "forget",
      "auth_key": Constants.auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Email Sent");
      await dialog.hide();
      CreateAlertDialog(context, _user_email);
    } else if (code == "0") {
      ShowResponse("Email Not Sent");
    } else if (code == "2") {
      ShowResponse("Email does not exist");
    } else {
      ShowResponse(response.body.toString());
    }
    await dialog.hide();
  }

  //Login Function End
  //Show Response Functions Start
  ShowResponse(String Response) {
    var snackBar = SnackBar(content: Text(Response));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<bool> _willPopCallback() async {
    Navigator.pop(context);
    return true;
    // return true if the route to be popped
  }

  //Show Response Function End
  String btn_text = "CHECK EMAIL";
  bool pass_enabled = false;
  bool email_enabled = true;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
        title: CustomTextWidget(
            color: Colors.white,
            fontsize: 0.025,
            isbold: true,
            text: 'Reset Password',
            textalign: TextAlign.start,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: formkey,
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextWidget(
                      text: 'Enter email below to reset password',
                      fontsize: 0.03,
                      isbold: true,
                      color: Colors.black,
                      textalign: TextAlign.center),
                  SizedBox(
                    height: 25,
                  ),
                  TextFieldWidget(
                    Tcontroller: _EmailController,
                    labeltext: 'Email',
                    obscure: false,
                    lines: 1,
                    enabled: email_enabled,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    Tcontroller: _PasswordController,
                    labeltext: 'Password',
                    obscure: true,
                    lines: 1,
                    enabled: pass_enabled,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldWidget(
                    Tcontroller: _CPasswordController,
                    labeltext: 'Confirm Password',
                    obscure: true,
                    lines: 1,
                    enabled: pass_enabled,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      var _user_email = _EmailController.text;
                      var _user_password = _PasswordController.text;
                      var _c_user_password = _CPasswordController.text;

                      if (!pass_enabled) {
                        if (_user_email == "" ||
                            !_user_email.contains("@") ||
                            !_user_email.contains(".")) {
                          ShowResponse("Please enter valid email");
                        } else {
                          SendEmail(_user_email);
                        }
                      } else {
                        if (_user_password == "") {
                          ShowResponse("Please enter password");
                        } else if (_user_password.length < 6) {
                          ShowResponse(
                              "Password must be at least 6 characters long");
                        } else if (_user_password != _c_user_password) {
                          ShowResponse("Password does not match");
                        } else {
                          Reset(_user_email, _user_password);
                        }
                      }
                    },
                    child: SmalllButtonWidget(
                        fontsize: 0.025,
                        height: 0.06,
                        text: btn_text,
                        width: 0.9,
                        size: size),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  CreateAlertDialog(BuildContext context, String email) {
    TextEditingController room_name_controller = new TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter Code sent to $email"),
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
                  SendEmail(email);
                },
              ),
              MaterialButton(
                elevation: 5.0,
                child: Text("Continue"),
                onPressed: () {
                  if (room_name_controller.text.toString() ==
                      emailValue.toString()) {
                    Navigator.of(context, rootNavigator: true).pop();
                    setState(() {
                      setState(() {
                        btn_text = "Reset";
                        pass_enabled = true;
                        email_enabled = false;
                      });
                      ShowResponse("Enter new password above");
                    });
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
