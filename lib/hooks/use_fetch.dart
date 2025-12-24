import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert';

// A custom hook that mimics useFetch
AsyncSnapshot<dynamic> useFetch(String url) {
  // useMemoized ensures the future isn't recreated on every build
  final memoizedFuture = useMemoized(() => http.get(Uri.parse(url)), [url]);

  // useFuture subscribes to the future and triggers a rebuild on change
  return useFuture(memoizedFuture);
}
