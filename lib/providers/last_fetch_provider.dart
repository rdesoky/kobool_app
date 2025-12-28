import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/shared_preferences_provider.dart';

class LastFetchNotifier extends Notifier<int> {
  // late final SharedPreferences _prefs;

  @override
  int build() {
    final prefs = ref.read(sharedPreferencesProvider);
    final lastFetch = prefs.getInt('last_fetch');
    return lastFetch ?? DateTime.now().millisecondsSinceEpoch;
  }

  Future<void> setLastFetch([int? timestamp]) {
    state = timestamp ?? DateTime.now().millisecondsSinceEpoch;
    return ref.read(sharedPreferencesProvider).setInt('last_fetch', state);
  }
}

final lastFetchProvider = NotifierProvider<LastFetchNotifier, int>(
  LastFetchNotifier.new,
);
