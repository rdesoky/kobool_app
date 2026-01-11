import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/widgets/filter_button.dart';
import 'package:kobool/widgets/user_attr_button.dart';

final filters = {
  "g": {"attr": UserAttr.gender, "title": "gender", "icon": Icons.male},
  "ag": {"attr": UserAttr.age, "title": "age", "icon": Icons.hourglass_bottom},
  "ht": {"attr": UserAttr.height, "title": "height", "icon": Icons.height},
  "wt": {"attr": UserAttr.weight, "title": "weight", "icon": Icons.scale},
  "sm": {"attr": UserAttr.smoke, "title": "smoke", "icon": Icons.smoke_free},
  "ms": {
    "attr": UserAttr.maritalStatus,
    "title": "marital_status",
    "icon": Icons.family_restroom,
  },
  "c": {"attr": UserAttr.country, "title": "country", "icon": Icons.map},
  "o": {"attr": UserAttr.origin, "title": "origin", "icon": Icons.map},
  "rc": {"attr": UserAttr.race, "title": "race", "icon": Icons.map},
  "re": {"attr": UserAttr.religion, "title": "religion", "icon": Icons.mosque},
};

class PageFilters extends HookWidget {
  const PageFilters({super.key});

  @override
  Widget build(BuildContext context) {
    final emptyArgs = useState<Map<String, dynamic>>({});
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        emptyArgs.value;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var filter in filters.entries.where(
          (entry) => pageArgs.containsKey(entry.key),
        ))
          FilterButton(filterKey: filter.key),
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.pushNamed(
        //       context,
        //       Routes.drill,
        //       arguments: {...pageArgs, "sum": filter.key},
        //     );
        //   },
        //   child: UserAttrButton(attr: filter.key, props: filter.value),
        // ),
      ],
    );
  }
}
