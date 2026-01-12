import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/dio_provider.dart';
import 'package:kobool/utils/user_attr.dart';
import 'package:kobool/widgets/drill_buttons.dart';
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
          return Future.delayed(const Duration(seconds: 0), () {
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
        centerTitle: false,
      ),

      body: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PageFilters(),
          Expanded(
            child: pageArgs.containsKey("sum")
                ? results.connectionState == ConnectionState.done
                      ? SummaryList(summary: results.data?.data ?? {})
                      : CircularProgressIndicator()
                : results.connectionState == ConnectionState.waiting
                ? CircularProgressIndicator()
                : results.hasError
                ? Text("Error: ${results.error}")
                : DrillButtons(),
          ),
        ],
      ),
    );
  }
}
