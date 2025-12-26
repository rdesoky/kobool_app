import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/providers/settings_provider.dart';
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
    final language = ref.watch(languageProvider) ?? "en";

    final countriesMap = useState<Map<String, String>>({});

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
    final countryItems = useMemoized(() {
      final entries = countriesMap.value.entries.toList();
      entries.sort((a, b) => a.value.compareTo(b.value));
      return entries
          .map((e) => DropdownMenuItem(value: e.value, child: Text(e.value)))
          .toList();
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

    return Scaffold(
      appBar: AppBar(title: const Text('Search'), centerTitle: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Find Your Match',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              DropdownButtonFormField<String>(
                initialValue: gender.value,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text('select'.tr())),
                  DropdownMenuItem(value: '0', child: Text('Male')),
                  DropdownMenuItem(value: '1', child: Text('Female')),
                ],
                onChanged: (val) => gender.value = val,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: age.value,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text('select'.tr())),
                  ...ageRanges.map(
                    (range) =>
                        DropdownMenuItem(value: range, child: Text(range)),
                  ),
                ],
                onChanged: (val) => age.value = val,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: country.value,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text('select'.tr())),
                  ...countryItems,
                ],
                onChanged: (val) => country.value = val,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: maritalStatus.value,
                decoration: const InputDecoration(
                  labelText: 'Marital Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.favorite),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text('select'.tr())),
                  DropdownMenuItem(
                    value: '1',
                    child: renderMaritalStatus(context, '1'),
                  ),
                  DropdownMenuItem(
                    value: '2',
                    child: renderMaritalStatus(context, '2'),
                  ),
                  DropdownMenuItem(
                    value: '3',
                    child: renderMaritalStatus(context, '3'),
                  ),
                  DropdownMenuItem(
                    value: '4',
                    child: renderMaritalStatus(context, '4'),
                  ),
                  DropdownMenuItem(
                    value: '5',
                    child: renderMaritalStatus(context, '5'),
                  ),
                  DropdownMenuItem(
                    value: '6',
                    child: renderMaritalStatus(context, '6'),
                  ),
                ],
                onChanged: (val) => maritalStatus.value = val,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: origin.value,
                decoration: const InputDecoration(
                  labelText: 'Origin Country',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text('select'.tr())),
                  ...countryItems,
                ],
                onChanged: (val) => origin.value = val,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final params = <String, dynamic>{};
                  if (gender.value != null) params['g'] = gender.value;
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
                    params['age'] = age.value;
                  }

                  Navigator.pushNamed(
                    context,
                    Routes.results,
                    arguments: params,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
