import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ResultsPage extends HookWidget {
  final int? page;
  const ResultsPage({super.key, this.page});
  @override
  Widget build(BuildContext context) {
    final results = useStream<List<Map<String, dynamic>>>(
      getResultsStream(),
      initialData: [],
    ).data;

    return results != null
        ? ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              return ListTile(
                title: Text(result['title']),
                subtitle: Text(result['description']),
              );
            },
          )
        : Center(child: CircularProgressIndicator());
  }

  Stream<List<Map<String, dynamic>>> getResultsStream() async* {
    // Simulate fetching results from an API
    await Future.delayed(Duration(seconds: 2));
    yield [
      {'title': 'Result 1', 'description': 'Description for Result 1'},
      {'title': 'Result 2', 'description': 'Description for Result 2'},
      {'title': 'Result 3', 'description': 'Description for Result 3'},
    ];
  }
}
