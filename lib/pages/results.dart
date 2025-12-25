import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/widgets/user_list.dart';
import 'package:http/http.dart' as http;

class ResultsPage extends HookWidget {
  const ResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var page = useState(0);
    final asyncFetch = useFetch(
      "http://dev.kobool.com/cgi-bin/query.pl?p=${page.value}",
    );
    // parsed fetch results body
    final results = useMemoized(() {
      if (asyncFetch.hasData) {
        final resp = asyncFetch.data as http.Response;
        final body = json.decode(resp.body) as Map<String, dynamic>;
        return body;
      }
      return null;
    }, [asyncFetch]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          results == null ? 'Searching...' : 'Found ${results['total']}',
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                spacing: 12,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (page.value > 0)
                    ElevatedButton(
                      onPressed: () {
                        page.value = page.value - 1;
                      },
                      child: Text("Previous page"),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      page.value = page.value + 1;
                    },
                    child: Text("Next page"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
