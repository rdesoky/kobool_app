//legacy providers, initialized in main.dart overrides
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/shared_preferences_provider.dart';

class LocaleNotifier extends Notifier<String?> {
  @override
  String? build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final locale = prefs.getString('locale') ?? 'ar'; // TODO: get system locale
    return locale;
  }

  void setLocale(String locale) {
    state = locale;
    ref.read(sharedPreferencesProvider).setString('locale', locale);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, String?>(
  LocaleNotifier.new,
);
