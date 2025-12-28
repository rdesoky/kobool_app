import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/shared_preferences_provider.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final index = prefs.getInt('theme_mode');
    return index != null ? ThemeMode.values[index] : ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode mode) {
    state = mode;
    return ref.read(sharedPreferencesProvider).setInt('theme_mode', mode.index);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
