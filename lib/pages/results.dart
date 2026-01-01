import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/hooks/use_fetch_pages.dart';
import 'package:kobool/providers/main_app_bar_provider.dart';
import 'package:kobool/widgets/user_list.dart';

class ResultsPage extends HookConsumerWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageArgs =
        (ModalRoute.of(context)!.settings.arguments ?? {})
            as Map<dynamic, dynamic>;
    final (asyncFetch, results, onAddPage) = useFetchPages(
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
      ),
      body: Center(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo is UserScrollNotification) {
              if (scrollInfo.direction == ScrollDirection.reverse) {
                ref.read(mainAppBarProvider.notifier).state = false;
              } else if (scrollInfo.direction == ScrollDirection.forward) {
                ref.read(mainAppBarProvider.notifier).state = true;
              }
            }
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              onAddPage();
            }
            return true;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: UserList(asyncFetch: asyncFetch, results: results),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
