import 'package:flutter/material.dart';
import '../login_page.dart';
import '../home_page.dart';
import '../screens/chat_screen.dart';

class RouteGenerator {
  static const String loginPage = '/login';
  static const String homePage = '/home';
  static const String chatPage = '/chat';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case chatPage:
        final args = settings.arguments is Map<String, dynamic>
            ? settings.arguments as Map<String, dynamic>
            : <String, dynamic>{};

        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            chatRoomId: args['chatRoomId']?.toString() ?? 'default_chat',
            otherUserId: args['otherUserId']?.toString() ?? '',
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => const LoginPage());
    }
  }
}
