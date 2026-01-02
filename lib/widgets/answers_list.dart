import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/widgets/answer_list_item.dart';
import 'package:kobool/widgets/load_more_item.dart';

class AnswersList extends HookWidget {
  final AsyncSnapshot<dynamic> asyncFetch;
  final Map<dynamic, dynamic>? results;
  final VoidCallback onLoadMore;
  const AnswersList({
    super.key,
    required this.asyncFetch,
    this.results,
    required this.onLoadMore,
  });
  @override
  Widget build(BuildContext context) {
    if (asyncFetch.connectionState == ConnectionState.waiting &&
        !asyncFetch.hasData) {
      return const Center(child: CircularProgressIndicator());
    }
    if (asyncFetch.hasError) {
      return Center(child: Text('Error: \\${asyncFetch.error}'));
    }
    if (!asyncFetch.hasData) {
      return const Center(child: Text('No data'));
    }
    try {
      final childList = results?['child_list'] as List<dynamic>? ?? [];
      return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 4.0),
        padding: const EdgeInsets.all(8.0),
        itemCount: childList.isEmpty
            ? 0
            : childList.length + 1, // add load more item
        itemBuilder: (context, i) {
          if (i >= childList.length) {
            // render load more list item
            return LoadMoreItem(onLoadMore: onLoadMore, asyncFetch: asyncFetch);
          }
          return AnswerListItem(index: i, props: childList[i]);
        },
      );
    } catch (e) {
      return Center(child: Text('Parse error: \\$e'));
    }
  }
}
