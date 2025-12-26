import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart';

import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/widgets/answers_list.dart';
import 'package:kobool/widgets/page_navigator.dart';

class ForumPage extends HookWidget {
  final Map<String, dynamic>? arguments;
  const ForumPage({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    var page = useState(0);
    final asyncFetch = useFetch(
      "http://dev.kobool.com/cgi-bin/qa/search_answers.pl",
      params: {"p": page.value, "ps": 10, ...arguments ?? {}},
    );
    // parsed fetch results body
    final results = useMemoized(() {
      if (asyncFetch.hasData) {
        final resp = asyncFetch.data as Response;
        final body = json.decode(resp.body) as Map<String, dynamic>;
        return body;
      }
      return null;
    }, [asyncFetch]);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AnswersList(
                page: page.value,
                asyncFetch: asyncFetch,
                results: results,
              ),
            ),
            PageNavigator(
              page: page.value,
              onPrevious: () {
                page.value = page.value - 1;
              },
              onNext: () {
                page.value = page.value + 1;
              },
            ),
          ],
        ),
      ),
    );
  }
}
