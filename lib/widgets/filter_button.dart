import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/utils/user_attr.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FilterButton extends HookConsumerWidget {
  const FilterButton({super.key, required this.filterKey});
  final String filterKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emptyArgs = useState<Map<String, dynamic>>({});
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        emptyArgs.value;
    final filterInfo = gFilters[filterKey];

    return InputChip(
      label: Text(filterInfo?.mapValue(ref, pageArgs[filterKey]) ?? ""),
      onDeleted: () {
        final args = {...pageArgs};
        args.remove(filterKey);
        Navigator.pushNamed(
          context,
          ModalRoute.of(context)!.settings.name!,
          arguments: args,
        );
      },
      onPressed: () {
        final args = {...pageArgs};
        args.remove(filterKey);
        args["sum"] = filterKey;
        Navigator.pushNamed(context, Routes.drill, arguments: args);
      },
    );
  }
}
