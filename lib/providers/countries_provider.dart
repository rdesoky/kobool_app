import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/locale_provider.dart';

class CountriesNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() {
    ref.watch(localeProvider); // watch to rebuild when locale changes

    // loop from 1 to 250 and add each country to the map
    final countries = <String, String>{};
    for (int i = 1; i < 245; i++) {
      countries[i.toString()] = "countries.$i".tr();
    }
    return countries;
  }

  Map<String, String> get countries => state;
}

final countriesProvider =
    NotifierProvider<CountriesNotifier, Map<String, String>>(
      CountriesNotifier.new,
    );
