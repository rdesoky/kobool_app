import 'package:flutter/material.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/utils/user_attr.dart';

class SummaryList extends StatelessWidget {
  const SummaryList({super.key, required this.summary});

  final Map<String, dynamic> summary;

  @override
  Widget build(BuildContext context) {
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        {};

    final colorScheme = Theme.of(context).colorScheme;
    final filter = gFilters[pageArgs["sum"]];

    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: 600,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: summary["child_list"].length,
            itemBuilder: (context, index) {
              final entry = summary["child_list"][index];
              return ListTile(
                tileColor: index.isEven
                    ? colorScheme.surfaceContainerHigh
                    : colorScheme.surfaceContainer,

                contentPadding: EdgeInsetsDirectional.only(start: 16),
                dense: true,
                onTap: () {
                  final args = {...pageArgs};
                  args[summary["summary_by"]] =
                      entry["group_name"]; // add filter
                  args.remove("sum"); // remove summary
                  Navigator.pushNamed(context, Routes.drill, arguments: args);
                },
                leading: Icon(Icons.add_outlined),
                title: Text(filter!.mapValue(context, entry["group_name"])),
                trailing: SizedBox(
                  width: 120,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      final args = {...pageArgs};
                      args[summary["summary_by"]] =
                          entry["group_name"]; // add filter
                      args.remove("sum"); // remove summary
                      Navigator.pushNamed(
                        context,
                        Routes.results,
                        arguments: args,
                      );
                    },
                    child: Text(entry["members_count"].toString()),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(height: 0),
          ),
        ),
      ),
    );
  }
}
