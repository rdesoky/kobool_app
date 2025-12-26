import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';

class SearchPage extends HookWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gender = useState<String?>(null);
    final countryController = useTextEditingController();
    final maritalStatus = useState<String?>(null);
    final originController = useTextEditingController();

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
                items: const [
                  DropdownMenuItem(value: null, child: Text('Any')),
                  DropdownMenuItem(value: 'M', child: Text('Male')),
                  DropdownMenuItem(value: 'F', child: Text('Female')),
                ],
                onChanged: (val) => gender.value = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: maritalStatus.value,
                decoration: const InputDecoration(
                  labelText: 'Marital Status',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.favorite),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Any')),
                  DropdownMenuItem(value: 'Single', child: Text('Single')),
                  DropdownMenuItem(value: 'Married', child: Text('Married')),
                  DropdownMenuItem(value: 'Divorced', child: Text('Divorced')),
                  DropdownMenuItem(value: 'Widowed', child: Text('Widowed')),
                ],
                onChanged: (val) => maritalStatus.value = val,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: originController,
                decoration: const InputDecoration(
                  labelText: 'Origin Country',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.flag),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final params = <String, dynamic>{};
                  if (gender.value != null) params['g'] = gender.value;
                  if (countryController.text.isNotEmpty) {
                    params['c'] = countryController.text;
                  }
                  if (maritalStatus.value != null) {
                    params['ms'] = maritalStatus.value;
                  }
                  if (originController.text.isNotEmpty) {
                    params['o'] = originController.text;
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
