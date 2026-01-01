import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/widgets/user_list_item.dart';
import 'package:visibility_detector/visibility_detector.dart';

class UserList extends HookWidget {
  final AsyncSnapshot<dynamic> asyncFetch;
  final Map<dynamic, dynamic>? results;
  final VoidCallback? onLoadMore;
  const UserList({
    super.key,
    required this.asyncFetch,
    this.results,
    this.onLoadMore,
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
      final childList = results?["child_list"] as List<dynamic>? ?? [];
      return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 0.0),
        padding: const EdgeInsets.all(8.0),
        itemCount: childList.length + 1, // add
        itemBuilder: (context, i) {
          if (i == childList.length) {
            // render loading indicator
            return VisibilityDetector(
              key: const Key('user-list-load-more'),
              onVisibilityChanged: (visibilityInfo) {
                // Trigger callback when the widget becomes visible
                if (visibilityInfo.visibleFraction > 0.1 &&
                    onLoadMore != null) {
                  onLoadMore!();
                }
              },
              child: SizedBox(
                height: 60,
                child: asyncFetch.connectionState == ConnectionState.waiting
                    ? const Center(child: CircularProgressIndicator())
                    : null,
              ),
            );
          }
          final item = childList[i] as Map<String, dynamic>;
          return UserListItem(props: item);
        },
      );
    } catch (e) {
      return Center(child: Text('Parse error: \\$e'));
    }
  }
}
