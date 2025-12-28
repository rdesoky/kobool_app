import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/locale_provider.dart';

class CountriesNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() {
    final locale = ref.watch(
      localeProvider,
    ); // watch to rebuild when locale changes
    rootBundle.loadString('assets/translations/$locale.json').then((value) {
      final jsonMap = json.decode(value) as Map<String, dynamic>;
      if (jsonMap.containsKey('countries')) {
        final countries = Map<String, String>.from(jsonMap['countries']);
        // Remove empty entries if any
        countries.removeWhere((key, value) => value.isEmpty);
        state = countries; // mutate the sate
      }
    });
    return {};
  }
}

final countriesProvider =
    NotifierProvider<CountriesNotifier, Map<String, String>>(
      CountriesNotifier.new,
    );
