import 'package:flutter/material.dart';
import 'package:kobool/pages/chat.dart';
import 'package:kobool/pages/drill.dart';
import 'package:kobool/pages/forum.dart';
import 'package:kobool/pages/home.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/pages/login.dart';
import 'package:kobool/pages/register.dart';
import 'package:kobool/pages/results.dart';
import 'package:kobool/pages/search.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return _buildRoute(const Home(), settings);
      case Routes.login:
        return _buildRoute(const Login(), settings);
      case Routes.register:
        return _buildRoute(const Register(), settings);
      case Routes.search:
        return _buildRoute(const Search(), settings);
      case Routes.results:
        return _buildRoute(const Results(), settings);
      case Routes.forum:
        return _buildRoute(const Forum(), settings);
      case Routes.drill:
        return _buildRoute(Drill(), settings);
      case Routes.chat:
        return _buildRoute(const Chat(), settings);
      // case Routes.editTask:
      //   return _buildRoute(EditTask(id: settings.arguments as int), settings);
      // case Routes.liveAgent:
      //   return _buildRoute(
      //     LiveAgentPage(initialThreadId: settings.arguments as String?),
      //     settings,
      //   );
      default:
        return _buildRoute(
          Center(child: Text('No route defined for ${settings.name}')),
          settings,
        );
    }
  }

  static Route<dynamic> _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => page, settings: settings);
    // return PageRouteBuilder(
    //   pageBuilder: (context, animation, secondaryAnimation) => page,
    //   transitionDuration: Duration.zero,
    //   reverseTransitionDuration: Duration.zero,
    //   settings: settings,
    // );
  }
}
