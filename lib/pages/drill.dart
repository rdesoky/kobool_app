import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/consts/query_params.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/dio_provider.dart';
import 'package:kobool/utils/context_extenstion.dart';
import 'package:kobool/utils/user_attr.dart';
import 'package:kobool/widgets/drill_buttons.dart';
import 'package:kobool/widgets/page_filters.dart';
import 'package:kobool/widgets/summary_list.dart';

class DrillPage extends HookConsumerWidget {
  const DrillPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final pageArgs = context.args;
    final results = useFuture(
      useMemoized(() {
        if (pageArgs.containsKey(QParams.summary)) {
          final spreadArgs =
              [
                SearchFilter.age,
                SearchFilter.weight,
                SearchFilter.height,
              ].contains(pageArgs[QParams.summary])
              ? {QParams.spread: 5}
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

    final totalMembers =
        results.data?.data["total_members"] ??
        context.args[QParams.totalMembers] ??
        0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          results.connectionState == ConnectionState.waiting
              ? 'grouping'.tr()
              : results.hasError
              ? 'Error: ${results.error}'
              : pageArgs.containsKey(QParams.summary)
              ? FilterInfo.fromFilter(results.data?.data["summary_by"]).title
              : "drill".tr(),
        ),
        centerTitle: false,
      ),

      body: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          PageFilters(
            leading: [
              if (totalMembers > 0)
                InputChip(
                  label: Text(totalMembers.toString()),
                  avatar: const Icon(Icons.people, size: 20),
                  onPressed: () {
                    pageArgs.remove(QParams.summary);
                    Navigator.pushNamed(
                      context,
                      Routes.results,
                      arguments: pageArgs,
                    );
                  },
                ),
            ],
            trailing: [
              if (pageArgs.containsKey(QParams.summary))
                IconButton(
                  icon: const Icon(Icons.person_search, size: 20),
                  constraints: const BoxConstraints(maxHeight: 35),
                  onPressed: () {
                    pageArgs.remove(QParams.summary);
                    Navigator.pushNamed(
                      context,
                      Routes.drill,
                      arguments: pageArgs,
                    );
                  },
                ),
              IconButton(
                icon: const Icon(Icons.forum, size: 20),
                constraints: const BoxConstraints(maxHeight: 35),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    Routes.forum,
                    arguments: {...pageArgs, "total": totalMembers},
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: pageArgs.containsKey(QParams.summary)
                ? results.connectionState == ConnectionState.done
                      ? SummaryList(summary: results.data?.data ?? {})
                      : Center(child: const CircularProgressIndicator())
                : results.connectionState == ConnectionState.waiting
                ? Center(child: const CircularProgressIndicator())
                : results.hasError
                ? Text("Error: ${results.error}")
                : DrillButtons(),
          ),
        ],
      ),
    );
  }
}
