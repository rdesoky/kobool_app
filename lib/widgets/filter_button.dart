import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/query_params.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/utils/context_extenstion.dart';
import 'package:kobool/utils/user_attr.dart';

class FilterButton extends HookConsumerWidget {
  const FilterButton({super.key, required this.filterKey});
  final String filterKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageArgs = context.args;
    final filterInfo = FilterInfo.fromFilter(filterKey);

    return InputChip(
      label: Text(filterInfo.mapValue(ref, pageArgs[filterKey])),
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
        args[QParams.summary] = filterKey;
        Navigator.pushNamed(context, Routes.drill, arguments: args);
      },
    );
  }
}
