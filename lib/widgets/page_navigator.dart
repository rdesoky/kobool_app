import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PageNavigator extends StatelessWidget {
  final int page;
  final int total;
  final Function() onPrevious;
  final Function() onNext;
  const PageNavigator({
    super.key,
    required this.page,
    required this.onPrevious,
    required this.onNext,
    this.total = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: page > 0 ? onPrevious : null,
            child: Text("previous".tr()),
          ),
          Text("page_number".tr(args: [(page + 1).toString()])),
          ElevatedButton(
            onPressed: page < total ? onNext : null,
            child: Text("next".tr()),
          ),
        ],
      ),
    );
  }
}
