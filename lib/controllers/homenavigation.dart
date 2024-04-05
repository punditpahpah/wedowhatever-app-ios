import 'package:get/get.dart';

class HomeNavigationController extends GetxController {
  RxInt count = 0.obs;
  RxInt returncount() {
    update();
    return count;
  }
}
