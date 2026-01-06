import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/hooks/use_fetch_pages.dart';
import 'package:kobool/widgets/user_list.dart';

class ResultsPage extends HookConsumerWidget {
  const ResultsPage({super.key, this.arguments});
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (asyncFetch, results, onLoadMore) = useFetchPages(
      ref,
      url: API.query,
      params: arguments,
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
