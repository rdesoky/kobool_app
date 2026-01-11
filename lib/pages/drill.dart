import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/dio_provider.dart';
import 'package:kobool/widgets/page_filters.dart';
import 'package:kobool/widgets/home_button.dart';
import 'package:kobool/widgets/summary_list.dart';

class DrillPage extends HookConsumerWidget {
  const DrillPage({super.key, this.arguments});
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context, ref) {
    final emptyArgs = useState<Map<String, dynamic>>({});
    final pageArgs = arguments ?? emptyArgs.value;
    final results = useFuture(
      useMemoized(() {
        if (pageArgs.containsKey("sum")) {
          final spreadArgs = ["ag", "wt", "ht"].contains(pageArgs["sum"])
              ? {"spr": 5}
              : {};
          return Future.delayed(const Duration(seconds: 1), () {
            return ref
                .read(dioProvider)
                .get(
                  API.grouping,
                  queryParameters: {...pageArgs, ...spreadArgs},
                );
          });
        }
        return Future.value(null);
      }, [pageArgs]),
    );
    final filters = useMemoized(() {
      return [
        ("gender", Icons.male, "g"),
        ("age", Icons.hourglass_bottom, "ag"),
        ("marital_status", Icons.family_restroom, "ms"),
        ("country", Icons.map, "c"),
        ("origin", Icons.map, "o"),
        ("race", Icons.map, "rc"),
        ("religion", Icons.mosque, "re"),
      ].where((filter) => !(pageArgs.containsKey(filter.$3))).toList();
    }, [pageArgs]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          results.connectionState == ConnectionState.waiting
              ? 'grouping'.tr()
              : results.hasError
              ? 'Error: ${results.error}'
              : pageArgs.containsKey("sum")
              ? results.data?.data["summary_by"]
              : "Drill",
        ),
        actions: [PageFilters()],
        centerTitle: false,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 600,
                    child: Column(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (pageArgs.containsKey("sum"))
                          if (results.connectionState == ConnectionState.done)
                            SummaryList(summary: results.data?.data ?? {})
                          else if (results.connectionState ==
                              ConnectionState.waiting)
                            CircularProgressIndicator()
                          else
                            Text("Error: ${results.error}")
                        else
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              for (var filter in filters)
                                HomeButton(
                                  label: filter.$1.tr(),
                                  icon: filter.$2,
                                  onPressed: pageArgs["sum"] != filter.$3
                                      ? () {
                                          Navigator.pushNamed(
                                            context,
                                            Routes.drill,
                                            arguments: {
                                              ...pageArgs,
                                              "sum": filter.$3,
                                            },
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
            ),
          );
        },
      ),
    );
  }
}
