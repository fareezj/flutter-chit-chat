import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';

class RouteGenerator {
  static const String loginPage = '/login';
  static const String homePage = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage()); // Default to login page
    }
  }
}
