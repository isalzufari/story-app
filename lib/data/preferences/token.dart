import 'package:shared_preferences/shared_preferences.dart';

class Token {
  static const token = "token";

  setToken(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(token, value);
  }

  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(token) ?? "";
  }
}
