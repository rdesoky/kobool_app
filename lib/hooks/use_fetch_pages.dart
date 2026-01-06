import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/hooks/use_fetch.dart';

(AsyncSnapshot<dynamic>, Map<dynamic, dynamic>, VoidCallback) useFetchPages(
  WidgetRef ref, {
  required String url,
  Map<String, dynamic>? params,
  int pageSize = 5,
}) {
  final page = useState(0);
  final loadedPagesCount = useState(0);

  final memoizedParams = useMemoized(
    () => {...?params, "p": page.value, "ps": pageSize},
    [params, page.value, pageSize],
  );

  final asyncFetch = useFetch(ref, url, params: memoizedParams);
  final loadedPages = useState<Map<int, List<dynamic>>>({});
  final total = useState(0);

  final results = useState<Map<dynamic, dynamic>>({});

  void updateResults() {
    //childList to expand up to 5 pages from startPage.value
    final childList = loadedPages.value.values
        // .skip(startPage.value)
        // .take(5)
        .expand((x) => x)
        .toList();

    final body = asyncFetch.hasData
        ? (asyncFetch.data as Response).data as Map<dynamic, dynamic>
        : {"total": 0};

    results.value = {...body, "child_list": childList};
  }

  // updated param value, reset the old results
  useEffect(() {
    loadedPages.value = {};
    page.value = 0;
    results.value = {"total": 0, "child_list": []};
    loadedPagesCount.value = 0;
    updateResults();
    return null;
  }, [params]);

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
      loadedPages.value = loadedPages.value..[bodyPage] = childList;
      loadedPagesCount.value = loadedPages.value.length;
      updateResults();
    }
    return null;
  }, [asyncFetch]);

  final onLoadMore = useCallback(() {
    page.value = loadedPages.value.keys.last + 1; //fetch next page
  }, []);

  return (asyncFetch, results.value, onLoadMore);
}
