import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:whatever_ios/routes/app_pages.dart';
import 'package:whatever_ios/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    new Future.delayed(
        const Duration(seconds: 5), () => Get.toNamed(AppRoutes.LOGIN));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/whatever_banner.png'),
          Padding(padding: EdgeInsets.only(top: 20.0)),
            CircularProgressIndicator(
              color: Colors.white,
              backgroundColor: CustomColors.DarkBlueColour,
              strokeWidth: 4.0,
           )
        ],
      )),
    );
  }
}
