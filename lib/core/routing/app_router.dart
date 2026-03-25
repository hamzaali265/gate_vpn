import 'package:flutter/material.dart';
import '../../modules/vpn/screens/home_screen.dart';
import '../../modules/vpn/screens/server_list_screen.dart';
import '../../modules/vpn/screens/splash_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String home = '/home';
  static const String serverList = '/server-list';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case serverList:
        return MaterialPageRoute(builder: (_) => const ServerListScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for \${settings.name}')),
          ),
        );
    }
  }
}
