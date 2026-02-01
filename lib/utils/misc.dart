import 'package:flutter/material.dart';
import 'package:kobool/consts/routes.dart';

Widget routeIcon(String routeName) {
  switch (routeName) {
    case Routes.home:
      return const Icon(Icons.home);
    case Routes.login:
      return const Icon(Icons.login);
    case Routes.register:
      return const Icon(Icons.person_add);
    case Routes.search:
      return const Icon(Icons.search);
    case Routes.results:
      return const Icon(Icons.people);
    case Routes.forum:
      return const Icon(Icons.forum);
    case Routes.drill:
      return const Icon(Icons.person_search);
    case Routes.chat:
      return const Icon(Icons.chat);
    case Routes.user:
      return const Icon(Icons.person);
    case Routes.contact:
      return const Icon(Icons.contact_mail);
    case Routes.settings:
      return const Icon(Icons.settings);
    default:
      return const Icon(Icons.error);
  }
}
