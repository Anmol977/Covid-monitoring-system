import 'package:shared_preferences/shared_preferences.dart';

import 'strings.dart';

class Token {
  static const String bearerString = 'Bearer ';
  static String token = '';
  static String scope = '';

  static Future<bool> isTokenAlreadySet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString(Strings.token) ?? '';
    if (token.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static void setScope(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Strings.scope, value);
  }

  static void setToken(String value) async {
    token = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Strings.token, token);
  }

  static Future<String> getScope() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    scope = prefs.getString(Strings.scope) ?? '';
    return scope;
  }

  static String get bearerToken {
    return bearerString + token;
  }

  static String get onlyToken {
    return token;
  }

  static void reset() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(Strings.token);
    prefs.remove(Strings.scope);
  }
}
