import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:kobool/consts/api.dart';

import 'package:kobool/hooks/use_fetch_pages.dart';
import 'package:kobool/widgets/answers_list.dart';
import 'package:kobool/widgets/page_navigator.dart';

class ForumPage extends HookConsumerWidget {
  final Map<String, dynamic>? arguments;
  const ForumPage({super.key, this.arguments});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final colorScheme = Theme.of(context).colorScheme;
    var page = useState(0);

    Map<String, dynamic>? fetchParams = useMemoized(() {
      final filtered = arguments != null
          ? Map<String, dynamic>.from(arguments!)
          : null;
      filtered?.removeWhere((key, _) => ["qtext"].contains(key));
      return filtered;
    }, [arguments]);

    final (asyncFetch, results, onAddPage) = useFetchPages(
      ref,
      url: API.searchAnswers,
      params: {"p": page.value, "ps": 10, ...?fetchParams},
    );
    // parsed fetch results body
    return Scaffold(
      appBar: AppBar(
        title: Text(
          asyncFetch.hasError
              ? 'Error: ${asyncFetch.error}'
              : asyncFetch.hasData
              ? (arguments?['qtext'] != null
                    ? '${arguments?['qtext']}'
                    : "qa_forum".tr())
              : 'searching'.tr(),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
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
                child: AnswersList(asyncFetch: asyncFetch, results: results),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
