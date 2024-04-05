
import 'package:get/get.dart';
import 'package:whatever_ios/views/NewsFeed/index.dart';
import 'package:whatever_ios/views/SplashScreen.dart';
import 'package:whatever_ios/views/about/all_about.dart';
import 'package:whatever_ios/views/alerts/alerts.dart';
import 'package:whatever_ios/views/chat/index.dart';
import 'package:whatever_ios/views/chat/personChat.dart';
import 'package:whatever_ios/views/friends/index.dart';
import 'package:whatever_ios/views/friends/viewProfile.dart';
import 'package:whatever_ios/views/home/index.dart';
import 'package:whatever_ios/views/signupLoginforms/login/index.dart';
import 'package:whatever_ios/views/viewPhotoVedios/photo.dart';
import 'package:whatever_ios/views/viewPhotoVedios/vedio.dart';
import 'package:whatever_ios/views/viewPhotoVedios/vedioPlayer.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
     GetPage(name: AppRoutes.SPLASH_SCREEN, page: () => SplashScreen()),
     GetPage(name: AppRoutes.HOME, page: () => Home(pgindex:0)),
     GetPage(name: AppRoutes.LOGIN, page: () => LoginForms()),
     GetPage(name: AppRoutes.ABOUT, page: () => AllAbout()),
     //GetPage(name: AppRoutes.PHOTOS, page: () => Photo()),
    //  GetPage(name: AppRoutes.VEDIOs, page: () => Vedio()),
    //   GetPage(name: AppRoutes.VEDIOPLAYER, page: () => VedioPlayer()),
      GetPage(name: AppRoutes.NEWSFEED, page: () => NewsFeed(from:"up")),
      //GetPage(name: AppRoutes.SINGLEUSERCHAT, page: () => SingleUserChat()),
     GetPage(name: AppRoutes.CHAT, page: () => chat(from:"top")),
     //GetPage(name: AppRoutes.FRIENDS, page: () => Friends()),
     GetPage(name: AppRoutes.USERPROFILE, page: () => ViewProfile(from: "user",id: "logged_in_user_id",)),
     GetPage(name: AppRoutes.Alerts, page: () => Alerts()),
  ];
}
