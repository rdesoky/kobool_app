import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:kobool/hooks/use_fetch.dart';

class Results extends HookWidget {
  const Results({super.key});

  @override
  Widget build(BuildContext context) {
    var page = useState(0);
    final searchResults = useFetch(
      "http://dev.kobool.com/cgi-bin/query.pl?p=${page.value}",
    );
    Widget resultsWidget;

    if (searchResults.connectionState == ConnectionState.waiting) {
      resultsWidget = const Center(child: CircularProgressIndicator());
    } else if (searchResults.hasError) {
      resultsWidget = Center(child: Text('Error: \\${searchResults.error}'));
    } else if (!searchResults.hasData) {
      resultsWidget = const Center(child: Text('No data'));
    } else {
      final resp = searchResults.data as http.Response;
      try {
        final jsonBody = json.decode(resp.body) as Map<String, dynamic>;
        final childList = (jsonBody['child_list'] as List<dynamic>?) ?? [];
        resultsWidget = ListView.builder(
          itemCount: childList.length,
          itemBuilder: (context, i) {
            final item = childList[i] as Map<String, dynamic>;
            final login = item['login_id'] ?? '';
            final age = item['age'] ?? item['ag'] ?? '';
            final title = item['ad_title'] ?? '';
            return ListTile(
              title: Text(login.toString()),
              subtitle: Text('Age: \\${age.toString()}  \\${title.toString()}'),
            );
          },
        );
      } catch (e) {
        resultsWidget = Center(child: Text('Parse error: \\$e'));
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Active members'), centerTitle: false),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Results", style: TextStyle(fontSize: 24)),
            SizedBox(
              height: 300,
              key: Key("search_results"),
              // child: ResultsPage(page: page.value),
              child: resultsWidget,
            ),
            Row(
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
          ],
        ),
      ),
    );
  }
}
