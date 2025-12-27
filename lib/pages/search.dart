import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/locale_provider.dart';
import 'package:kobool/utils/user_attr.dart';

class SearchPage extends HookConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gender = useState<String?>(null);
    final country = useState<String?>(null);
    final maritalStatus = useState<String?>(null);
    final origin = useState<String?>(null);
    final age = useState<String?>(null);
    final language = ref.watch(localeProvider) ?? "en";

    final countriesMap = useState<Map<String, String>>({});
    final middleEast = [
      56,
      110,
      12,
      3,
      93,
      49,
      59,
      87,
      98,
      69,
      117,
      106,
      149,
      77,
      102,
      79,
      83,
      62,
      63,
      32,
      66,
    ];

    useEffect(() {
      Future<void> loadCountries() async {
        try {
          final jsonString = await rootBundle.loadString(
            'assets/translations/$language.json',
          );
          final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
          if (jsonMap.containsKey('countries')) {
            final countries = Map<String, String>.from(jsonMap['countries']);
            // Remove empty entries if any
            countries.removeWhere((key, value) => value.isEmpty);
            countriesMap.value = countries;
          }
        } catch (e) {
          debugPrint('Error loading countries: $e');
        }
      }

      loadCountries();
      return null;
    }, []);

    // Sorted list of country names for the dropdown
    final middleEastCountryItems = useMemoized(() {
      final middleEastEntries = countriesMap.value.entries
          .where((e) => middleEast.contains(int.parse(e.key)))
          .toList();
      middleEastEntries.sort((a, b) => a.value.compareTo(b.value));
      return middleEastEntries
          .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
          .toList();
    }, [countriesMap.value]);

    final nonMiddleEastCountryItems = useMemoized(() {
      final nonMiddleEastEntries = countriesMap.value.entries
          .where((e) => !middleEast.contains(int.parse(e.key)))
          .toList();
      nonMiddleEastEntries.sort((a, b) => a.value.compareTo(b.value));
      return nonMiddleEastEntries.map((e) {
        return DropdownMenuItem(
          value: e.key,
          child: e == nonMiddleEastEntries.first
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Divider(), Text(e.value)],
                )
              : Text(e.value),
        );
      }).toList();
    }, [countriesMap.value]);

    final ageRanges = [
      '16-24',
      '25-29',
      '30-34',
      '35-39',
      '40-44',
      '45-49',
      '50-54',
      '55-59',
      '60-64',
      '65-69',
      '70-74',
      '75-79',
      '80-84',
      '85-89',
      '90-95',
    ];

    void onSearch() {
      final params = <String, dynamic>{};
      if (gender.value != null) {
        params['g'] = gender.value;
      }
      if (country.value != null) {
        params['c'] = country.value;
      }
      if (maritalStatus.value != null) {
        params['ms'] = maritalStatus.value;
      }
      if (origin.value != null) {
        params['o'] = origin.value;
      }
      if (age.value != null) {
        params['ag'] = age.value;
      }

      Navigator.pushNamed(context, Routes.results, arguments: params);
    }

    return Scaffold(
      appBar: AppBar(title: Text('search'.tr()), centerTitle: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SizedBox(
            width: 360,
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'find_your_match'.tr(),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                DropdownButtonFormField<String>(
                  initialValue: gender.value,
                  decoration: InputDecoration(
                    labelText: 'gender'.tr(),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text('select'.tr())),
                    DropdownMenuItem(value: '0', child: Text('male'.tr())),
                    DropdownMenuItem(value: '1', child: Text('female'.tr())),
                  ],
                  onChanged: (val) => gender.value = val,
                ),
                DropdownButtonFormField<String>(
                  initialValue: age.value,
                  decoration: InputDecoration(
                    labelText: 'age'.tr(),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.cake),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text('select'.tr())),
                    ...ageRanges.map(
                      (range) => DropdownMenuItem(
                        value: ageRangeToQueryParam(range),
                        child: Text(range),
                      ),
                    ),
                  ],
                  onChanged: (val) => age.value = val,
                ),
                DropdownButtonFormField<String>(
                  initialValue: country.value,
                  decoration: InputDecoration(
                    labelText: 'country'.tr(),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text('select'.tr())),
                    ...middleEastCountryItems,
                    // DropdownMenuItem(child: Divider()),
                    ...nonMiddleEastCountryItems,
                  ],
                  onChanged: (val) => country.value = val,
                ),
                DropdownButtonFormField<String>(
                  initialValue: maritalStatus.value,
                  decoration: InputDecoration(
                    labelText: 'marital_status'.tr(),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.favorite),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text('select'.tr())),
                    ...List.generate(6, (i) => (i + 1).toString()).map(
                      (val) => DropdownMenuItem(
                        value: val,
                        child: renderMaritalStatus(context, val),
                      ),
                    ),
                  ],
                  onChanged: (val) => maritalStatus.value = val,
                ),
                DropdownButtonFormField<String>(
                  initialValue: origin.value,
                  decoration: InputDecoration(
                    labelText: 'origin_country'.tr(),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.flag),
                  ),
                  items: [
                    DropdownMenuItem(value: null, child: Text('select'.tr())),
                    ...middleEastCountryItems,
                    // DropdownMenuItem(child: Divider()),
                    ...nonMiddleEastCountryItems,
                  ],
                  onChanged: (val) => origin.value = val,
                ),
                ElevatedButton(
                  onPressed: onSearch,
                  style: ElevatedButton.styleFrom(
                    // padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: Text('search'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
