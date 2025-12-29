import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/dio_provider.dart';
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
  // We generate a string key to stabilize the dependency array.
  final memoizedParamsKey = useMemoized(
    () => params?.entries.map((e) => "${e.key}=${e.value}").join("&"),
    [params],
  );
  final memoizedPayloadKey = useMemoized(
    () => payload?.entries.map((e) => "${e.key}=${e.value}").join("&"),
    [payload],
  );

  final memoizedFuture = useMemoized(() async {
    await Future.delayed(const Duration(milliseconds: 200));
    ref
        .read(lastFetchProvider.notifier)
        .setLastFetch(); // set last fetch timestamp after a delay

    final dio = ref.read(dioProvider);

    if (payload != null) {
      return dio.post(url, data: payload);
    }

    return dio.get(
      url,
      queryParameters: params,
      // options: Options(
      //   headers: {'Cookie': ref.read(userSessionProvider).toCookieString()},
      // ),
    );
  }, [url, memoizedParamsKey, memoizedPayloadKey]);

  // useFuture subscribes to the future and triggers a rebuild on change
  return useFuture(memoizedFuture);
}
