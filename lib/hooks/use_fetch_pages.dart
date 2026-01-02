import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/hooks/use_fetch.dart';

(AsyncSnapshot<dynamic>, Map<dynamic, dynamic>, VoidCallback) useFetchPages(
  WidgetRef ref, {
  required String url,
  Map<dynamic, dynamic> params = const {},
  int pageSize = 5,
}) {
  final page = useState(0);
  final asyncFetch = useFetch(
    ref,
    url,
    params: {...params, "p": page.value, "ps": pageSize},
  );
  final pages = useState<Map<int, List<dynamic>>>({});
  final total = useState(0);
  final startPage = useState(0);
  // final loadedPages = pages.value.values.length;

  final results = useState<Map<dynamic, dynamic>>({
    "total": 0,
    "child_list": [],
  });

  useEffect(() {
    if (asyncFetch.hasData) {
      final resp = asyncFetch.data as Response;
      final body = resp.data as Map<dynamic, dynamic>;
      if (body["child_list"] == null) {
        return null; //nothing found
      }
      final bodyPage = int.parse(body["page"].toString());
      final childList = body["child_list"] as List;
      for (var i = 0; i < childList.length; i++) {
        childList[i]["index"] =
            bodyPage * pageSize + i; //write absolute index in each item
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

    final body = asyncFetch.hasData
        ? asyncFetch.data.data as Map<dynamic, dynamic>
        : {"total": 0};

    results.value = {...body, "child_list": childList};
    return null;
  }, [pages.value.length, startPage.value]);

  final onLoadMore = useCallback(() {
    page.value = pages.value.keys.last + 1; //fetch next page
    // if (loadedPages >= 4) {
    //   //trim pages from above
    //   startPage.value = page.value - 3;
    // }
  }, []);

  return (asyncFetch, results.value, onLoadMore);
}
