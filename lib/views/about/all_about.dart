import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatever_ios/routes/app_pages.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/theme/constants.dart';
import 'package:whatever_ios/views/about/web.dart';
import 'package:whatever_ios/views/signupLoginforms/signup/index.dart';
import 'package:whatever_ios/views/social_logins/social_logins.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:whatever_ios/widgets/SmallButtonWidget.dart';
import 'package:whatever_ios/widgets/TextFormFieldWidget.dart';
import 'package:http/http.dart' as http;
import 'package:whatever_ios/widgets/social_btn.dart';

class AllAbout extends StatefulWidget {
  const AllAbout({Key? key}) : super(key: key);

  @override
  _AllAboutState createState() => _AllAboutState();
}

class _AllAboutState extends State<AllAbout> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
        prefs.setString('user_id', data[0]['user_id']);
        prefs.setString('user_firstname', data[0]['user_firstname']);
        prefs.setString('user_lastname', data[0]['user_lastname']);
        prefs.setString('user_avatar', data[0]['user_avatar']);
        //prefs.setString('user_lastname', data[0]['user_password']);
        prefs.setString('email', data[0]['email']);
        prefs.setString('is_logged_in', 'yes');
      }

      addStringToSF();
      await dialog.hide();

      Get.toNamed(
        AppRoutes.HOME,
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

  //Show Response Function End

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: CustomColors.DarkBlueColour,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: CustomTextWidget(
          color: CustomColors.DarkBlueColour,
          fontsize: 0.025,
          isbold: true,
          text: 'About',
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
                Hero(
                  tag: 'splash',
                  child: Image.asset(
                    'assets/images/whatever_banner.jpg',
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                // for icons
                GestureDetector(
                  onTap: () async {
                    final RouteResponse = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Web(link:"https://wedowhatever.com/application/about/about.html",title:"About Us"),
                      ),
                    );

                    
                  },
                  child: SmalllButtonWidget(
                      fontsize: 0.025,
                      height: 0.06,
                      text: 'About Us',
                      width: 0.9,
                      size: size,),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    final RouteResponse = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Web(link:"https://wedowhatever.com/application/about/terms.html",title: "Terms and the Conditions Policy"),
                      ),
                    );

                    
                  },
                  child: SmalllButtonWidget(
                      fontsize: 0.025,
                      height: 0.06,
                      text: 'Terms and the Conditions Policy',
                      width: 0.9,
                      size: size,),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () async {
                    final RouteResponse = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Web(link:"https://wedowhatever.com/application/about/privacy.html",title: "Privacy Policy"),
                      ),
                    );

                    
                  },
                  child: SmalllButtonWidget(
                      fontsize: 0.025,
                      height: 0.06,
                      text: 'Privacy Policy',
                      width: 0.9,
                      size: size,),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: ()  async{
                    final RouteResponse = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Web(link:"https://wedowhatever.com/application/about/cookie.html",title: "Cookies Policy"),
                      ),
                    );

                    
                  },
                  child: SmalllButtonWidget(
                      fontsize: 0.025,
                      height: 0.06,
                      text: 'Cookies Policy',
                      width: 0.9,
                      size: size,),
                ),
                SizedBox(
                  height: 15,
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
