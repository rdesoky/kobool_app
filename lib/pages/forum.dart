import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/hooks/use_fetch_pages.dart';
import 'package:kobool/modals/question_list.dart';
import 'package:kobool/widgets/answers_list.dart';
import 'package:kobool/widgets/filters_buttons.dart';

class ForumPage extends HookConsumerWidget {
  const ForumPage({super.key, this.arguments});
  final Map<String, dynamic>? arguments;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic>? fetchParams = useMemoized(() {
      final filtered = arguments != null
          ? Map<String, dynamic>.from(arguments!)
          : null;
      return filtered;
    }, [arguments]);

    final (asyncFetch, results, onLoadMore) = useFetchPages(
      ref,
      url: API.searchAnswers,
      params: fetchParams,
    );

    // parsed fetch results body
    return Scaffold(
      // bottomSheet: bottomSheetWidget.value,
      appBar: AppBar(
        title: Tooltip(
          message: results['question_text'] ?? "qa_forum".tr(),
          child: Text(
            asyncFetch.hasError
                ? 'Error: ${asyncFetch.error}'
                : asyncFetch.hasData
                ? results['question_text'] ?? "qa_forum".tr()
                : 'searching'.tr(),
          ),
        ),
        centerTitle: false,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
        actions: [
          FiltersButtons(),
          IconButton(
            icon: const Icon(Icons.find_in_page_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                constraints: const BoxConstraints(
                  maxWidth: 640,
                  minHeight: 400,
                  maxHeight: 600,
                ),
                builder: (context) => QuestionList(),
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AnswersList(
                asyncFetch: asyncFetch,
                results: results,
                onLoadMore: onLoadMore,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
