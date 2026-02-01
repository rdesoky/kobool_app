import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/utils/context_extenstion.dart';
import 'package:kobool/utils/user_attr.dart';
import 'package:kobool/widgets/summary_list_item.dart';

class SummaryList extends ConsumerWidget {
  const SummaryList({super.key, required this.summary});

  final Map<String, dynamic> summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageArgs = context.args;

    final filter = FilterInfo.fromFilter(pageArgs["sum"]);

    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 600,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: summary["child_list"].length,
            itemBuilder: (context, index) {
              final entry = summary["child_list"][index];
              return SummaryListItem(
                entry: entry,
                index: index,
                filter: filter,
                pageArgs: pageArgs,
                summary: summary,
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 0),
          ),
        ),
      ),
    );
  }
}
