import 'package:flutter/material.dart';
import 'package:kobool/consts/routes.dart';

class SummaryList extends StatelessWidget {
  const SummaryList({super.key, required this.summary});

  final Map<String, dynamic> summary;

  @override
  Widget build(BuildContext context) {
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        {};
    return ListView.separated(
      shrinkWrap: true,
      itemCount: summary["child_list"].length,
      itemBuilder: (context, index) {
        final entry = summary["child_list"][index];
        return ListTile(
          onTap: () {
            final args = {...pageArgs};
            args[summary["summary_by"]] = entry["group_name"]; // add filter
            args.remove("sum"); // remove summary
            Navigator.pushNamed(context, Routes.drill, arguments: args);
          },
          leading: Text(entry["group_name"].toString()),
          trailing: SizedBox(
            width: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () {
                final args = {...pageArgs};
                args[summary["summary_by"]] = entry["group_name"]; // add filter
                args.remove("sum"); // remove summary
                Navigator.pushNamed(context, Routes.results, arguments: args);
              },
              child: Text(entry["members_count"].toString()),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}
