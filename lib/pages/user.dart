import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/utils/context_extenstion.dart';
import 'package:kobool/utils/user_attr.dart';
import 'package:kobool/widgets/user_list_item.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageArgs = context.args;
    final asyncFetch = useFetch(ref, API.user, params: {"id": pageArgs['id']});
    final pageTitle =
        asyncFetch.hasData &&
            asyncFetch.data.data[UserAttribute.pageTitle] != null
        ? asyncFetch.data.data[UserAttribute.pageTitle].replaceAll("|u|", "")
        : "";

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (asyncFetch.hasData) ...[
              Text(asyncFetch.data.data[UserAttribute.loginName]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  pageTitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.colorScheme.tertiary,
                    fontSize: 20,
                  ),
                ),
              ),
            ] else
              const CircularProgressIndicator(),
          ],
        ),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (asyncFetch.connectionState == ConnectionState.waiting)
                const CircularProgressIndicator(),
              if (asyncFetch.hasError) Text('Error: ${asyncFetch.error}'),
              if (asyncFetch.hasData)
                UserListItem(
                  props: asyncFetch.data.data as Map<String, dynamic>,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
