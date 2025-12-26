import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/widgets/user_attr_button.dart';

class AnswerListItem extends HookWidget {
  final int index;
  final Map<String, dynamic> props;
  const AnswerListItem({super.key, required this.index, required this.props});

  @override
  Widget build(BuildContext context) {
    final pageArgs =
        (ModalRoute.of(context)!.settings.arguments ?? {})
            as Map<dynamic, dynamic>;

    final login = props['login_id'];
    final userId = props['member_id'] ?? props['id'];
    final questionId = props['question_text_id'];
    final questionText = props['question_text'];
    final answerText = props['answer_text'];

    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 1,
        // borderOnForeground: false,
        // color: colorScheme.surfaceBright,
        child: SizedBox(
          width: 600,
          // height: double.infinity,
          // constraints: BoxConstraints(minHeight: 120),
          child: ListTile(
            onTap: () {
              if (pageArgs['qid'] == null) {
                Navigator.pushNamed(
                  context,
                  Routes.forum,
                  arguments: {"qid": questionId, "qtext": questionText},
                );
              } else {
                Navigator.pushNamed(context, Routes.user, arguments: userId);
              }
            },
            isThreeLine: true,
            minTileHeight: 120,
            leading: UserAttrButton(attr: UserAttr.pic, props: props),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Wrap(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      login.toString(),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  UserAttrButton(attr: UserAttr.gender, props: props),
                  UserAttrButton(attr: UserAttr.age, props: props),
                  UserAttrButton(attr: UserAttr.maritalStatus, props: props),
                  UserAttrButton(attr: UserAttr.country, props: props),
                ],
              ),
            ),
            subtitle: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (pageArgs['qid'] == null)
                  Text(
                    questionText,
                    style: TextStyle(color: colorScheme.primary),
                  ),
                Text(
                  answerText,
                  style: TextStyle(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
