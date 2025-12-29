import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cookieJarProvider = Provider<CookieJar>((ref) {
  return CookieJar();
});

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  final cookieJar = ref.watch(cookieJarProvider);

  if (!kIsWeb) {
    dio.interceptors.add(CookieManager(cookieJar));
  }

  // Custom interceptor to inject UserSession cookies for legacy auth support
  // This ensures that even if cookies aren't managed by CookieJar (e.g. manually constructed),
  // they are still sent.
  // dio.interceptors.add(
  //   InterceptorsWrapper(
  //     onRequest: (options, handler) {
  //       final userSession = ref.read(userSessionProvider);
  //       final sessionCookies = userSession.toCookieString();

  //       // We append session cookies to existing cookies if any
  //       if (sessionCookies.isNotEmpty) {
  //         final existingCookies = options.headers['cookie'];
  //         if (existingCookies != null &&
  //             existingCookies is String &&
  //             existingCookies.isNotEmpty) {
  //           options.headers['cookie'] = "$existingCookies; $sessionCookies";
  //         } else {
  //           options.headers['cookie'] = sessionCookies;
  //         }
  //       }

  //       handler.next(options);
  //     },
  //   ),
  // );

  return dio;
});
