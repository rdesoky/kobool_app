import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/hooks/use_fetch_pages.dart';
import 'package:kobool/utils/context_extenstion.dart';
import 'package:kobool/widgets/page_filters.dart';
import 'package:kobool/widgets/user_list.dart';

class ResultsPage extends HookConsumerWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageArgs = context.args;
    final (asyncFetch, results, onLoadMore) = useFetchPages(
      ref,
      url: API.query,
      params: pageArgs,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          asyncFetch.connectionState == ConnectionState.waiting
              ? 'searching'.tr()
              : asyncFetch.hasError
              ? 'Error: ${asyncFetch.error}'
              : 'found_total'.tr(args: [results["total"].toString()]),
        ),
        centerTitle: false,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_search, size: 20),
            constraints: const BoxConstraints(maxHeight: 35),
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.drill,
                arguments: {...pageArgs, "total": results["total"]},
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
                arguments: {...pageArgs, "total": results["total"]},
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PageFilters(trailing: [
                
              ],
            ),
            Expanded(
              child: UserList(
                asyncFetch: asyncFetch,
                results: results,
                onLoadMore: onLoadMore,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
