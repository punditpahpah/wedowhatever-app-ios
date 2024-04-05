
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:whatever_ios/routes/app_pages.dart';
import 'package:whatever_ios/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: CustomColors.DarkBlueColour, // status bar color
  ));
  // WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize(
  //     debug: true // optional: set false to disable printing logs to console
  //     );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'whatever',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: CustomColors.DarkBlueColour,
        iconTheme: IconThemeData(color: CustomColors.DarkBlueColour),
        fontFamily: 'Montserrat',
      ),

      getPages: AppPages.routes,
      //unknownRoute: AppPages.unknownRoute,
      initialRoute: AppRoutes.LOGIN,
    );
  }
}
