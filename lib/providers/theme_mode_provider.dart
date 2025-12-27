import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/shared_preferences_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  late final SharedPreferences _prefs;

  @override
  ThemeMode build() {
    _prefs = ref.read(sharedPreferencesProvider);
    return _init(_prefs);
  }

  static ThemeMode _init(SharedPreferences prefs) {
    final index = prefs.getInt('theme_mode');
    return index != null ? ThemeMode.values[index] : ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) {
    state = mode;
    return _prefs.setInt('theme_mode', mode.index);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
