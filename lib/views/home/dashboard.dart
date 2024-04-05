import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatever_ios/routes/app_pages.dart';
import 'package:whatever_ios/views/friends/index.dart';
import 'package:whatever_ios/views/signupLoginforms/login/index.dart';
import 'package:whatever_ios/widgets/CustomTextWidget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

var user_id, user_firstname, user_lastname, user_avatar, email;

class _DashboardState extends State<Dashboard> {
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    user_lastname = prefs.getString('user_lastname');
    user_firstname = prefs.getString('user_firstname');
    user_avatar = prefs.getString('user_avatar');
    email = prefs.getString('email');
    setState(() {});
  }

  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }

  Future<bool> _willPopCallback() async {
    SystemNavigator.pop();
    return true;
    // return true if the route to be popped
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                header(),
                Expanded(
                    flex: 8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          RowWidget(
                              iconData1: Icons.account_circle,
                              iconData2: Icons.rss_feed_sharp,
                              text1: 'My Profile',
                              text2: 'Feeds',
                              link1: AppRoutes.USERPROFILE,
                              link2: AppRoutes.NEWSFEED,
                              size: size),
                          RowWidget(
                              iconData1: Icons.chat,
                              iconData2: Icons.warning,
                              text1: 'Messages',
                              link1: AppRoutes.CHAT,
                              link2: AppRoutes.Alerts,
                              text2: 'Alerts',
                              size: size),
                          RowWidget(
                              iconData1: Icons.info,
                              iconData2: Icons.logout,
                              text1: 'About Us',
                              link1: AppRoutes.ABOUT,
                              link2: AppRoutes.LOGIN,
                              text2: 'Logout',
                              size: size),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RowWidget extends StatelessWidget {
  RowWidget({
    required this.iconData1,
    required this.iconData2,
    required this.text1,
    required this.text2,
    required this.link1,
    required this.link2,
    Key? key,
    required this.size,
  }) : super(key: key);

  String text1, text2;
  IconData iconData1, iconData2;
  String link1, link2;

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: InkWell(
          onTap: () {
            Get.toNamed(link1);
          },
          child: Container(
            height: 150,
            width: size.width * 0.5,
            padding: EdgeInsets.only(left: 10, right: 5, bottom: 5, top: 5),
            child: IconWidget(
              iconData: iconData1,
              text: text1,
            ),
          ),
        )),
        Expanded(
            child: InkWell(
          onTap: () async {
            if (text2 == "Logout") {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              await preferences.clear();
            }
            Get.toNamed(link2);
          },
          child: Container(
            height: 150,
            width: size.width * 0.5,
            padding: EdgeInsets.only(left: 5, right: 10, bottom: 5, top: 5),
            child: IconWidget(
              iconData: iconData2,
              text: text2,
            ),
          ),
        )),
      ],
    );
  }
}

class IconWidget extends StatelessWidget {
  IconWidget({
    required this.iconData,
    required this.text,
    Key? key,
  }) : super(key: key);

  String text;
  IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      //borderRadius: BorderRadius.all(Radius.circular(15),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 40,
            ),
            CustomTextWidget(
                text: text,
                fontsize: 0.025,
                isbold: false,
                color: Colors.black,
                textalign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}

class header extends StatelessWidget {
  const header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 2,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (user_avatar == "Empty")
                CircleAvatar(
                  radius: 30,
                  child: Image.asset('assets/images/default_avatar.png'),
                ),
              if (user_avatar != "Empty")
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(user_avatar),
                  backgroundColor: Colors.transparent,
                ),
              SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: CustomTextWidget(
                        text: user_firstname + " " + user_lastname,
                        fontsize: 0.03,
                        isbold: false,
                        color: Colors.black,
                        textalign: TextAlign.start),
                  ),
                  CustomTextWidget(
                      text: 'Welcome Back',
                      fontsize: 0.02,
                      isbold: false,
                      color: Colors.black,
                      textalign: TextAlign.start)
                ],
              )
            ],
          ),
        ));
  }
}
