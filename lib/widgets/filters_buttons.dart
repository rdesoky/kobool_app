import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FiltersButtons extends HookWidget {
  const FiltersButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final emptyArgs = useState<Map<String, dynamic>>({});
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        emptyArgs.value;

    return const Placeholder();
  }
}
