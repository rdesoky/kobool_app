import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/widgets/user_view.dart';

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
    if (asyncFetch.connectionState == ConnectionState.waiting) {
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
