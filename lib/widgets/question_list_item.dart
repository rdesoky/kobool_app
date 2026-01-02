import 'package:flutter/material.dart';

class QuestionListItem extends StatelessWidget {
  final int index;
  final Map<dynamic, dynamic> item;
  final VoidCallback? onTouch;

  const QuestionListItem({
    super.key,
    required this.index,
    required this.item,
    this.onTouch,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final gender = int.parse(item['gender'].toString());
    final isMale = gender == 0;
    final genderColor = isMale ? Colors.blue : Colors.pink;

    return Material(
      color: index % 2 == 0
          ? colorScheme.surface
          : colorScheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTouch,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar Icon
              Icon(
                isMale ? Icons.male : Icons.female,
                size: 40,
                color: genderColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text:
                                item['question_text'] ??
                                item['question'] ??
                                'Unknown Question',
                          ),
                          TextSpan(
                            text: '(${item['answer_count'] ?? 0})',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.star_border, color: colorScheme.outline),
                onPressed: () {
                  // Toggle favorite placeholder
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
