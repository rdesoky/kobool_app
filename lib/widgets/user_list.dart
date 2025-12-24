import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/widgets/user_view.dart';
import 'package:http/http.dart' as http;

class UserList extends HookWidget {
  final int? page;
  const UserList({super.key, this.page});
  @override
  Widget build(BuildContext context) {
    final searchResults = useFetch(
      "http://dev.kobool.com/cgi-bin/query.pl?p=${page ?? 0}",
    );
    if (searchResults.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (searchResults.hasError) {
      return Center(child: Text('Error: \\${searchResults.error}'));
    } else if (!searchResults.hasData) {
      return const Center(child: Text('No data'));
    } else {
      final resp = searchResults.data as http.Response;
      try {
        final body = json.decode(resp.body) as Map<String, dynamic>;
        final childList = (body['child_list'] as List<dynamic>?) ?? [];
        return Center(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
            padding: const EdgeInsets.all(8.0),
            itemCount: childList.length,
            itemBuilder: (context, i) {
              final item = childList[i] as Map<String, dynamic>;
              return UserView(index: i, props: item);
            },
          ),
        );
      } catch (e) {
        return Center(child: Text('Parse error: \\$e'));
      }
    }
  }
}
