import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/utils/user_attr.dart';
import 'package:kobool/widgets/filter_button.dart';

class PageFilters extends HookWidget {
  const PageFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final emptyArgs = useState<Map<String, dynamic>>({});
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        emptyArgs.value;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 600,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var filter in gFilters.entries.where(
                (entry) => pageArgs.containsKey(entry.key),
              ))
                FilterButton(filterKey: filter.key),
            ],
          ),
        ),
      ),
    );
  }
}
