import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/hooks/use_fetch_pages.dart';
import 'package:kobool/widgets/load_more_item.dart';
import 'package:kobool/widgets/question_list_item.dart';

class QuestionList extends HookConsumerWidget {
  const QuestionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final filterController = useTextEditingController();
    final filter = useState("");
    final params = useState<Map<String, dynamic>>({});

    useEffect(() {
      params.value = filter.value.isNotEmpty
          ? {"search": filter.value}
          : const {};
      return null;
    }, [filter.value]);

    final (asyncFetch, results, onLoadMore) = useFetchPages(
      ref,
      url: API.questionList,
      params: params.value,
      pageSize: 10,
    );

    final childList = results['child_list'] as List<dynamic>? ?? [];

    void onSearchSubmit() {
      filter.value = filterController.text;
    }

    return Container(
      color: colorScheme.surface,
      constraints: const BoxConstraints(minHeight: 500),
      child: Column(
        children: [
          // Header with close button
          Container(
            color: colorScheme.primary, // M3 Primary
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          // Filter Bar
          Container(
            color:
                colorScheme.surfaceContainerHigh, // M3 Surface Container High
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    // height: 32,
                    child: TextFormField(
                      autofocus: true,
                      controller: filterController,
                      decoration: InputDecoration(hintText: 'filter'.tr()),
                      onFieldSubmitted: (_) => onSearchSubmit(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onPressed: () {
                      onSearchSubmit();
                    },
                    child: Text('search'.tr()),
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.separated(
              itemCount: childList.isEmpty ? 0 : childList.length + 1,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: colorScheme.outlineVariant),
              itemBuilder: (context, index) {
                if (index >= childList.length) {
                  return LoadMoreItem(
                    onLoadMore: onLoadMore,
                    asyncFetch: asyncFetch,
                  );
                }
                return QuestionListItem(
                  index: index,
                  item: childList[index],
                  onTouch: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(
                      Routes.forum,
                      arguments: {"qid": childList[index]['question']},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
