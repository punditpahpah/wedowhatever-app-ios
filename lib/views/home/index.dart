import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatever_ios/controllers/homenavigation.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:whatever_ios/views/NewsFeed/index.dart';
import 'package:whatever_ios/views/chat/index.dart';
import 'package:whatever_ios/views/feeds/feeds.dart';
import 'package:whatever_ios/views/friends/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class Home extends StatefulWidget {
   Home({Key? key, this.pgindex=0}) : super(key: key);
  int pgindex;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  getStringValuesSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id');
    setState(() {});
  }
  @override
  void initState() {
    getStringValuesSF();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    HomeNavigationController homeNavigationController =
        Get.put(HomeNavigationController());

    homeNavigationController.count.value = widget.pgindex;

    void _onItemTapped(int index) {
      print(index.toString());
      homeNavigationController.count.value = index;
    }
 
    var size = MediaQuery.of(context).size;

    final items = <Widget>[
      new Dashboard(),
      new NewsFeed(from:"bottom"),
      new Friends(user_id: user_id,from:"bottom", context: context),
      new chat(from:"bottom")
    ];

    return Obx(() => Scaffold(
        body: Container(
          width: size.width * 1,
          height: size.height * 1,
          child: items[homeNavigationController.count.value],
        ),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 5,
          //selectedFontSize: 20,
          selectedIconTheme: IconThemeData(color: CustomColors.DarkBlueColour),
          unselectedIconTheme: IconThemeData(color: CustomColors.darkGreyColor),
          selectedItemColor: CustomColors.DarkBlueColour,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedLabelStyle: TextStyle(color: CustomColors.DarkBlueColour),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rss_feed_sharp),
              label: 'Feed',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              label: 'Friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Messages',
            ),
          ],
          currentIndex: homeNavigationController.count.value, //New
          onTap: _onItemTapped,
        )));
  }
}
