import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/widgets/user_attr_button.dart';

class UserListItem extends HookWidget {
  final Map<String, dynamic> props;
  const UserListItem({super.key, required this.props});

  @override
  Widget build(BuildContext context) {
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        {};
    final login = props['login_id'] ?? '';
    final title = props['ad_title'] ?? '';
    final selfDesc = props['self_desc'] ?? '';
    final mateDesc = props['mate_desc'] ?? '';

    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        children: [
          if (props['index'] != null) Text("${props['index'] + 1}"),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: colorScheme.surfaceContainerHighest),
            ),
            elevation: 0,
            // borderOnForeground: false,
            // color: colorScheme.surfaceBright,
            child: SizedBox(
              width: 600,
              // height: double.infinity,
              // constraints: BoxConstraints(minHeight: 120),
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.user,
                    arguments: {...pageArgs, "id": props['id']},
                  );
                },
                isThreeLine: true,
                minTileHeight: 120,
                leading: UserAttrButton(attr: UserAttr.pic, props: props),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    spacing: 12,
                    children: [
                      Text(
                        login.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Text(
                          title.toString().replaceAll("|u|", ""),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: colorScheme.tertiary),
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Column(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        UserAttrButton(attr: UserAttr.gender, props: props),
                        UserAttrButton(attr: UserAttr.age, props: props),
                        UserAttrButton(
                          attr: UserAttr.maritalStatus,
                          props: props,
                        ),
                        UserAttrButton(attr: UserAttr.country, props: props),
                        UserAttrButton(attr: UserAttr.origin, props: props),
                      ],
                    ),
                    Text(
                      selfDesc.toString().replaceAll("|u|", ""),
                      style: TextStyle(color: colorScheme.tertiary),
                    ),
                    Text(mateDesc.toString().replaceAll("|u|", "")),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
