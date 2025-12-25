import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/router_provider.dart';
import 'package:kobool/providers/settings_provider.dart';

class KAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const KAppBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    String routeName = ref.watch(routerProvider).name.replaceAll("/", "");
    final brightness = Theme.of(context).brightness;
    return AppBar(
      title: Text("Kobool - $routeName"),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
      actions: [
        IconButton(
          icon: Icon(
            brightness == Brightness.light ? Icons.dark_mode : Icons.light_mode,
          ),
          onPressed: () {
            ref
                .read(themeModeProvider.notifier)
                .state = brightness == Brightness.light
                ? ThemeMode.dark
                : ThemeMode.light;
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
