import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:kobool/app_main.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: Locale('ar'),
        child: AppMain(),
      ),
    ),
  );
}
