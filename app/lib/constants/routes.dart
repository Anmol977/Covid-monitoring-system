import 'package:covmon/screens/home/home.dart';
import 'package:covmon/screens/login/login.dart';
import 'package:covmon/screens/selector/selector.dart';
import 'package:covmon/screens/signup/signup.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String select = '/select';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
}

final Map<String, WidgetBuilder> routes = {
  Routes.select: (context) => const SelectorScreen(),
  Routes.login: (context) => const LoginScreen(),
  Routes.signup: (context) => const SignupScreen(),
  Routes.home: (context) => const HomeScreen(),
};
