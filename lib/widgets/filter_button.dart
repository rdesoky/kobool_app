import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';

class FilterButton extends HookWidget {
  const FilterButton({super.key, required this.filterKey});
  final String filterKey;

  @override
  Widget build(BuildContext context) {
    final emptyArgs = useState<Map<String, dynamic>>({});
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        emptyArgs.value;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
      onPressed: () {
        final args = {...pageArgs};
        args.remove(filterKey);
        args["sum"] = filterKey;
        Navigator.pushNamed(context, Routes.drill, arguments: args);
      },
      child: Text(filterKey),
    );
  }
}
