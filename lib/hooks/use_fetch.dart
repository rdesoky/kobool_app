import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:kobool/providers/last_fetch_provider.dart';
import 'package:kobool/providers/user_session_provider.dart';

// A custom hook that mimics useFetch
AsyncSnapshot<dynamic> useFetch(
  WidgetRef ref,
  String url, {
  Map<String, dynamic>? params,
  Map<String, dynamic>? payload,
}) {
  // useMemoized ensures the future isn't recreated on every build
  final memoizedParams = useMemoized(
    () => params?.entries
        .map((e) => "${e.key}=${Uri.encodeComponent(e.value.toString())}")
        .join("&"),
    [params],
  );
  final memoizedPayload = useMemoized(
    () => payload?.entries
        .map((e) => "${e.key}=${Uri.encodeComponent(e.value.toString())}")
        .join("&"),
    [payload],
  );
  final memoizedFuture = useMemoized(() async {
    ref.read(lastFetchProvider.notifier).setLastFetch();

    await Future.delayed(const Duration(milliseconds: 200));
    if (payload != null) {
      return post(Uri.parse(url), body: memoizedPayload);
    }
    return get(
      Uri.parse("$url?$memoizedParams"),
      headers: {'Cookie': ref.read(userSessionProvider).toCookie()},
    );
  }, [url, memoizedParams, memoizedPayload]);

  // useFuture subscribes to the future and triggers a rebuild on change
  return useFuture(memoizedFuture);
}
