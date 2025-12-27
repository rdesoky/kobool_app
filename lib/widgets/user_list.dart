import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/widgets/user_list_item.dart';

class UserList extends HookWidget {
  final int? page;
  final AsyncSnapshot<dynamic> asyncFetch;
  final Map<String, dynamic>? results;
  const UserList({
    super.key,
    this.page,
    required this.asyncFetch,
    this.results,
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
        separatorBuilder: (context, index) => const SizedBox(height: 0.0),
        padding: const EdgeInsets.all(8.0),
        itemCount:
            childList.length +
            (asyncFetch.connectionState == ConnectionState.waiting ? 1 : 0),
        itemBuilder: (context, i) {
          if (i == childList.length &&
              asyncFetch.connectionState == ConnectionState.waiting) {
            // render loading indicator
            return SizedBox(
              height: 100,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final item = childList[i] as Map<String, dynamic>;
          return UserListItem(index: i, props: item);
        },
      );
    } catch (e) {
      return Center(child: Text('Parse error: \\$e'));
    }
  }
}
