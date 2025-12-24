import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/router_provider.dart';

class KAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const KAppBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    String routeName = ref.watch(routerProvider).name;
    return AppBar(
      title: Text("Kobool$routeName"),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      // iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
