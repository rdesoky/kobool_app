import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
// Legacy provider to support watching localeProvider
import 'package:flutter_riverpod/legacy.dart';
import 'package:kobool/providers/locale_provider.dart';

// action/dispatcher/reducer for List<String>
class CountriesNotifier extends StateNotifier<Map<String, String>> {
  final dynamic ref;

  CountriesNotifier(this.ref) : super({}) {
    _init();
  }

  Future<void> _init() async {
    final locale = ref.watch(localeProvider);
    final jsonString = await rootBundle.loadString(
      'assets/translations/$locale.json',
    );
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    if (jsonMap.containsKey('countries')) {
      final countries = Map<String, String>.from(jsonMap['countries']);
      // Remove empty entries if any
      countries.removeWhere((key, value) => value.isEmpty);
      state = countries; // mutate the sate
    }
  }
}

final countriesProvider =
    StateNotifierProvider<CountriesNotifier, Map<String, String>>((ref) {
      return CountriesNotifier(ref);
    });
