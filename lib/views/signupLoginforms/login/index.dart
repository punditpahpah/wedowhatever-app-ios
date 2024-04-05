import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatever_ios/routes/app_pages.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/forget/forget_email.dart';
import 'package:whatever_ios/views/home/index.dart';
import 'package:whatever_ios/views/signupLoginforms/signup/index.dart';
import 'package:whatever_ios/views/social_logins/social_logins.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:whatever_ios/widgets/SmallButtonWidget.dart';
import 'package:whatever_ios/widgets/TextFormFieldWidget.dart';
import 'package:http/http.dart' as http;
import 'package:whatever_ios/widgets/social_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginForms extends StatefulWidget {
  const LoginForms({Key? key}) : super(key: key);

  @override
  _LoginFormsState createState() => _LoginFormsState();
}

class _LoginFormsState extends State<LoginForms> {
  

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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

  //Login Function Start
  Future Login(String _user_email, String _user_password) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var url = Uri.parse(Constants.base_url + "login.php");
    var response = await http.post(url, body: {
      "email": _user_email,
      "password": _user_password,
      "auth_key": Constants.auth_key
    });
    var data = json.decode(response.body);
    var code = data[0]['code'];
    if (code == "1") {
      ShowResponse("Logged in Successfully");
      addStringToSF() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('is_logged_in', "yes");
        prefs.setString('user_id', data[0]['user_id']);
        prefs.setString('user_firstname', data[0]['user_firstname']);
        prefs.setString('user_lastname', data[0]['user_lastname']);
        prefs.setString('user_avatar', data[0]['user_avatar']);
        //prefs.setString('user_lastname', data[0]['user_password']);
        prefs.setString('email', data[0]['email']);
      }

      addStringToSF();
      await dialog.hide();

      // Get.toNamed(
      //   AppRoutes.HOME,
      // );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false,
      );
      // var route = new MaterialPageRoute(
      //     builder: (BuildContext context) => new SocialLogins());
      //Navigator.of(context).push(route);
    } else if (code == "2") {
      ShowResponse("Account is not active");
    } else if (code == "0") {
      ShowResponse("Invalid Credentials");
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
    SystemNavigator.pop();
    return true;
    // return true if the route to be popped
  }

  //Show Response Function End

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: formkey,
              child: ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Hero(
                    tag: 'splash',
                    child: Image.asset(
                      'assets/images/whatever_banner.jpg',
                    ),
                  ),
                  SizedBox(
                    height: 25,
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
                  InkWell(
                    onTap: () {
                      var _user_email = _EmailController.text;
                      var _user_password = _PasswordController.text;
                      if (_user_email == "" ||
                          !_user_email.contains("@") ||
                          !_user_email.contains(".")) {
                        ShowResponse("Please enter valid email");
                      } else if (_user_password == "") {
                        ShowResponse("Please enter password");
                      } else {
                        Login(_user_email, _user_password);
                      }
                    },
                    child: SmalllButtonWidget(
                        fontsize: 0.025,
                        height: 0.06,
                        text: 'LOGIN',
                        width: 0.9,
                        size: size),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CustomTextWidget(
                      text: 'Or login with',
                      fontsize: 0.03,
                      isbold: false,
                      color: Colors.black,
                      textalign: TextAlign.center),
                  SizedBox(
                    height: 15,
                  ),
                  // for icons
                  GestureDetector(
                    onTap: () async {
                      final RouteResponse = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SocialLogins(to: 'Google', color: "0xFFBB001B"),
                        ),
                      );

                      Login(RouteResponse, "socialxxxx123321123321098890ffsdfsdghniohien5!@#*(^(*!@#*&*buisfbkjnhau12354868034(*&!");
                    },
                    child: SocialBtnWidget(
                        fontsize: 0.025,
                        height: 0.06,
                        text: 'Login with Google',
                        width: 0.9,
                        size: size,
                        link: "assets/images/google.png",
                        color: "0xFFBB001B"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final RouteResponse = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SocialLogins(to: 'Twitter', color: "0xFF00acee"),
                        ),
                      );

                      Login(RouteResponse, "socialxxxx123321123321098890ffsdfsdghniohien5!@#*(^(*!@#*&*buisfbkjnhau12354868034(*&!");
                    },
                    child: SocialBtnWidget(
                        fontsize: 0.025,
                        height: 0.06,
                        text: 'Login with Twitter',
                        width: 0.9,
                        size: size,
                        link: "assets/images/twitter.png",
                        color: "0xFF00acee"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      signInWithFacebook();
                      // final RouteResponse = await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         SocialLogins(to: 'Facebook', color: "0xFF3b5998"),
                      //   ),
                      // );

                      // Login(RouteResponse, "socialxxxx123321123321098890");
                    },
                    child: SocialBtnWidget(
                        fontsize: 0.025,
                        height: 0.06,
                        text: 'Login with Facebook',
                        width: 0.9,
                        size: size,
                        link: "assets/images/facebook.png",
                        color: "0xFF3b5998"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final RouteResponse = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SocialLogins(to: 'Linkedin', color: "0xFF0077b5"),
                        ),
                      );

                      Login(RouteResponse, "socialxxxx123321123321098890ffsdfsdghniohien5!@#*(^(*!@#*&*buisfbkjnhau12354868034(*&!");
                    },
                    child: SocialBtnWidget(
                        fontsize: 0.025,
                        height: 0.06,
                        text: 'Login with Linkedin',
                        width: 0.9,
                        size: size,
                        link: "assets/images/linkedin.png",
                        color: "0xFF0077b5"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextWidget(
                          text: 'Do not have an account?',
                          fontsize: 0.03,
                          isbold: false,
                          color: Colors.black,
                          textalign: TextAlign.center),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          Get.to(SignUpForms());
                        },
                        child: SmalllButtonWidget(
                            fontsize: 0.025,
                            height: 0.06,
                            text: 'REGISTER NOW',
                            width: 0.9,
                            size: size),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          var route = new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new ForgetEmail());
                          Navigator.of(context).push(route);
                        },
                        child: CustomTextWidget(
                            text: 'Forgot password?',
                            fontsize: 0.03,
                            isbold: false,
                            color: Colors.black,
                            textalign: TextAlign.center),
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
      ),
    );
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult =
        await FacebookAuth.instance.login(permissions: ['email']);

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final UserData = await FacebookAuth.instance.getUserData();

    var email=UserData["email"];
    var name=email.split("@");
    Register(name[0], "N/A", email, "socialxxxx123321123321098890ffsdfsdghniohien");
    // Once signed in, return the UserCredential                            
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
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
      Login(_user_email, "socialxxxx123321123321098890ffsdfsdghniohien5!@#*(^(*!@#*&*buisfbkjnhau12354868034(*&!");
      
    } else if (code == "0") {
      await dialog.hide();
      Login(_user_email, "socialxxxx123321123321098890ffsdfsdghniohien5!@#*(^(*!@#*&*buisfbkjnhau12354868034(*&!");
    } else {
      ShowResponse(response.body.toString());
    }
    await dialog.hide();
  }
}
