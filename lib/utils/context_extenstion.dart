import 'package:flutter/material.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/utils/empty_args.dart';

extension ContextExtension on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Map<String, dynamic> get args =>
      ModalRoute.of(this)?.settings.arguments as Map<String, dynamic>? ??
      EmptyArgs().instance;
  String get routeName => ModalRoute.of(this)?.settings.name ?? '';
  String get resultsRoute {
    return [Routes.results, Routes.drill, Routes.forum].contains(routeName)
        ? routeName
        : Routes.results;
  }
}
