import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/dio_provider.dart';
import 'package:kobool/widgets/home_button.dart';

class DrillPage extends HookConsumerWidget {
  const DrillPage({super.key, this.arguments});
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context, ref) {
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        {};
    final results = useFuture(
      useMemoized(() {
        if (pageArgs.containsKey("sum")) {
          final spreadArgs = ["ag", "wt", "ht"].contains(pageArgs["sum"])
              ? {"spr": 5}
              : {};
          return ref
              .read(dioProvider)
              .get(API.grouping, queryParameters: {...pageArgs, ...spreadArgs});
        }
        return Future.value(null);
      }, [pageArgs]),
    );
    final filters = useMemoized(() {
      return [
        ("gender".tr(), Icons.male, "g"),
        ("age".tr(), Icons.hourglass_bottom, "ag"),
        ("marital_status".tr(), Icons.family_restroom, "ms"),
        ("country".tr(), Icons.map, "c"),
        ("origin".tr(), Icons.map, "o"),
        ("race".tr(), Icons.map, "rc"),
        ("religion".tr(), Icons.mosque, "re"),
      ].where((filter) => !(pageArgs.containsKey(filter.$3))).toList();
    }, [pageArgs]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          results.connectionState == ConnectionState.waiting
              ? 'searching'.tr()
              : results.hasError
              ? 'Error: ${results.error}'
              : "Drill",
        ),

        centerTitle: false,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (arguments?.containsKey("sum") ?? false)
                  if (results.connectionState == ConnectionState.done)
                    Text(results.data.toString())
                  else if (results.connectionState == ConnectionState.waiting)
                    CircularProgressIndicator()
                  else
                    Text("Error: ${results.error}"),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (var filter in filters)
                      HomeButton(
                        label: filter.$1,
                        icon: filter.$2,
                        onPressed: pageArgs["sum"] != filter.$3
                            ? () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.drill,
                                  arguments: {...pageArgs, "sum": filter.$3},
                                );
                              }
                            : null,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
