import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class LoadMoreItem extends StatelessWidget {
  final VoidCallback? onLoadMore;
  final AsyncSnapshot<dynamic> asyncFetch;
  const LoadMoreItem({super.key, this.onLoadMore, required this.asyncFetch});

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key('user-list-load-more'),
      onVisibilityChanged: (visibilityInfo) {
        // Trigger callback when the widget becomes visible
        if (visibilityInfo.visibleFraction > 0.1 && onLoadMore != null) {
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
}
