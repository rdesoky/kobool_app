import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:kobool/app_main.dart';

void main() {
  // runApp(const AppMain());
  runApp(const ProviderScope(child: AppMain()));
}
