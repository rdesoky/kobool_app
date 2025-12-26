import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/widgets/page_navigator.dart';
import 'package:kobool/widgets/user_list.dart';

class ResultsPage extends HookWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var page = useState(0);
    final asyncFetch = useFetch(
      "http://dev.kobool.com/cgi-bin/query.pl",
      params: {"p": page.value},
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
          asyncFetch.connectionState == ConnectionState.waiting
              ? 'searching'.tr()
              : asyncFetch.hasError
              ? 'Error: ${asyncFetch.error}'
              : 'found_total'.tr(args: [results?["total"]]),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: UserList(
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
