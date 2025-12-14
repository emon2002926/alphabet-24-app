import 'package:get_storage/get_storage.dart';

class UserInfo {

  static void setAccessToken(String token) {
    final box = GetStorage();
    box.write('accessToken', token);
  }
  static String? getAccessToken() {
    final box = GetStorage();
    return box.read('accessToken');
  }

  static void clearUserInfo() {
    final box = GetStorage();
    box.erase();
  }
}