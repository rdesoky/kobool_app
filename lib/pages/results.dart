import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/providers/main_app_bar_provider.dart';
import 'package:kobool/widgets/user_list.dart';

class ResultsPage extends HookConsumerWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var page = useState(0);
    const pageSize = 5;
    var pages = useState<Map<int, List<dynamic>>>({});
    var total = useState(0);
    var startPage = useState(0);
    var loadedPages = pages.value.values.length;

    final pageArgs =
        (ModalRoute.of(context)!.settings.arguments ?? {})
            as Map<dynamic, dynamic>;

    final asyncFetch = useFetch(
      ref,
      API.query,
      params: {...pageArgs, "p": page.value, "ps": pageSize},
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
        final bodyPage = int.parse(body["page"].toString());
        if (body["child_list"] == null) {
          return null;
        }
        final childList = body["child_list"] as List;
        for (var i = 0; i < childList.length; i++) {
          childList[i]["index"] = bodyPage * pageSize + i;
        }
        total.value = int.parse(body["total"].toString());

        pages.value = pages.value..[bodyPage] = childList;
      }
      return null;
    }, [asyncFetch]);

    useEffect(() {
      //childList to expand up to 5 pages from startPage.value
      final childList = pages.value.values
          // .skip(startPage.value)
          // .take(5)
          .expand((x) => x)
          .toList();
      results.value = {"total": total.value, "child_list": childList};
      return null;
    }, [pages.value.length, startPage.value]);

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
            if (scrollInfo is UserScrollNotification) {
              if (scrollInfo.direction == ScrollDirection.reverse) {
                ref.read(mainAppBarProvider.notifier).state = false;
              } else if (scrollInfo.direction == ScrollDirection.forward) {
                ref.read(mainAppBarProvider.notifier).state = true;
              }
            }
            // if (scrollInfo.metrics.axisDirection == AxisDirection.down &&
            //     scrollInfo.metrics.pixels > 10) {
            //   ref.read(mainAppBarProvider.notifier).state = false;
            // }
            // if (startPage.value > 0 && scrollInfo.metrics.pixels == 0) {
            //   //TODO: avoid multiple decrementing
            //   startPage.value = startPage.value - 1;
            // }
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              page.value = pages.value.keys.last + 1; //fetch next page
              // if (loadedPages >= 4) {
              //   //trim pages from above
              //   startPage.value = page.value - 3;
              // }
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
            ],
          ),
        ),
      ),
    );
  }
}
