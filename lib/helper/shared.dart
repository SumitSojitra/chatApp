import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  HelperFunction._();
  static String userLoginKey = "LOGINKEY";

  static HelperFunction helperFunction = HelperFunction._();

  Future<bool?> getUserLoggedInStastus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoginKey);
  }
}
