import 'package:get/get.dart';

class MyController extends GetxController {
  RxBool pass = true.obs;
  RxBool pass1 = true.obs;
  RxBool pass2 = true.obs;

  void ShowPassWord() {
    pass.value = !pass.value;
  }

  void ShowPassWord1() {
    pass1.value = !pass1.value;
  }

  void ShowPassWord2() {
    pass2.value = !pass2.value;
  }
}
