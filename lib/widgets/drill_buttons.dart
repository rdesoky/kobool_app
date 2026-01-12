import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/utils/user_attr.dart';
import 'package:kobool/widgets/home_button.dart';

class DrillButtons extends HookWidget {
  const DrillButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final emptyArgs = useState<Map<String, dynamic>>({});
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        emptyArgs.value;

    final filters = useMemoized(() {
      return gFilters.entries
          .where((filter) => !(pageArgs.containsKey(filter.value.attr)))
          .toList();
    }, [pageArgs]);

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 600,
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  for (var filter in filters)
                    HomeButton(
                      label: filter.value.title,
                      icon: filter.value.icon,
                      onPressed: pageArgs["sum"] != filter.key
                          ? () {
                              Navigator.pushNamed(
                                context,
                                Routes.drill,
                                arguments: {...pageArgs, "sum": filter.key},
                              );
                            }
                          : null,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
