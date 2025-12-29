import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/app_main.dart';
import 'package:kobool/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: EasyLocalization(
        supportedLocales: [Locale('ar'), Locale('en')],
        path: 'assets/translations',
        fallbackLocale: Locale('ar'),
        child: AppMain(),
      ),
    ),
  );
}
