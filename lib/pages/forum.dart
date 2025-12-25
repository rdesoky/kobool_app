import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart';

import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/widgets/answers_list.dart';

class ForumPage extends HookWidget {
  final Map<String, dynamic>? arguments;
  const ForumPage({super.key, this.arguments});

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    var page = useState(0);
    final asyncFetch = useFetch(
      "http://dev.kobool.com/cgi-bin/qa/search_answers.pl",
      params: {"p": page.value, ...arguments ?? {}},
    );
    // parsed fetch results body
    final results = useMemoized(() {
      if (asyncFetch.hasData) {
        final resp = asyncFetch.data as Response;
        final body = json.decode(resp.body) as Map<String, dynamic>;
        return body;
      }
      return null;
    }, [asyncFetch]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          asyncFetch.hasError
              ? 'Error: ${asyncFetch.error}'
              : asyncFetch.hasData
              ? (arguments?['qtext'] != null
                    ? 'Answers for: ${arguments?['qtext']}'
                    : 'QA Forum')
              : 'Searching...',
        ),
        centerTitle: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AnswersList(
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
                  ElevatedButton(
                    onPressed: page.value > 0
                        ? () {
                            page.value = page.value - 1;
                          }
                        : null,
                    child: Text("Previous page"),
                  ),
                  Text("Page ${page.value + 1}"),
                  ElevatedButton(
                    onPressed: page.value < 100
                        ? () {
                            page.value = page.value + 1;
                          }
                        : null,
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
