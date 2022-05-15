import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  MySharedPref._();

  static SharedPreferences? sharedPreferences;
  static final MySharedPref instance = MySharedPref._();

  Future<SharedPreferences> getInstance() async {
    if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance();
      return sharedPreferences!;
    } else {
      return sharedPreferences!;
    }
  }

  Future<bool> clearAllData() async {
    SharedPreferences prefs = await getInstance();
    return prefs.clear();
  }

  Future<bool> saveToken(String token) async {
    SharedPreferences prefs = await getInstance();
    print("saveToken: $token");
    return prefs.setString('AUTH2_TOKEN', token);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await getInstance();
    String token = prefs.getString('AUTH2_TOKEN') ?? "";
    return token;
  }

  Future<bool> saveRefreshToken(String token) async {
    SharedPreferences prefs = await getInstance();
    print("saveRefreshToken: $token");
    return prefs.setString('REFRESH_TOKEN', token);
  }

  Future<String> getRefreshToken() async {
    SharedPreferences prefs = await getInstance();
    String token = prefs.getString('REFRESH_TOKEN') ?? "";
    return token;
  }

  Future<bool> saveExist(bool isExist) async {
    SharedPreferences prefs = await getInstance();
    print("setExist: $isExist");
    return prefs.setBool('IS_EXIST', isExist);
  }

  Future<bool> getExist() async {
    SharedPreferences prefs = await getInstance();
    bool isExist = prefs.getBool('IS_EXIST') ?? false;
    return isExist;
  }
}
