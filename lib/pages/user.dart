import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/api.dart';
import 'package:kobool/hooks/use_fetch.dart';
import 'package:kobool/utils/context_extenstion.dart';
import 'package:kobool/widgets/user_list_item.dart';

class UserPage extends HookConsumerWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageArgs = context.args;
    final asyncFetch = useFetch(ref, API.user, params: {"id": pageArgs['id']});

    return Scaffold(
      appBar: AppBar(title: const Text('User'), centerTitle: false),

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
