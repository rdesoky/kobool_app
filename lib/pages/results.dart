import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart';
import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/widgets/user_list.dart';

class ResultsPage extends HookWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var page = useState(0);
    var pages = useState<Map<int, List<dynamic>>>({});

    final pageArgs =
        (ModalRoute.of(context)!.settings.arguments ?? {})
            as Map<dynamic, dynamic>;

    final asyncFetch = useFetch(
      "http://dev.kobool.com/cgi-bin/query.pl",
      params: {...pageArgs, "p": page.value},
    );
    var results = useState<Map<String, dynamic>>({
      "total": 0,
      "child_list": [],
    });

    // parsed fetch results body
    useEffect(() {
      if (asyncFetch.hasData) {
        final resp = asyncFetch.data as Response;
        final body = json.decode(resp.body) as Map<String, dynamic>;
        final total = results.value["total"] + int.parse(body["total"]);
        pages.value = pages.value
          ..[int.parse(body["page"].toString())] = body["child_list"];
        final childList = pages.value.values.expand((x) => x).toList();
        results.value = {"total": total, "child_list": childList};
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
              : 'found_total'.tr(args: [results.value["total"].toString()]),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              page.value = pages.value.keys.last + 1; //fetch next page
            }
            return true;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: UserList(
                  page: page.value,
                  asyncFetch: asyncFetch,
                  results: results.value,
                ),
              ),
              // PageNavigator(
              //   page: page.value,
              //   onPrevious: () {
              //     page.value = page.value - 1;
              //   },
              //   onNext: () {
              //     page.value = page.value + 1;
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
