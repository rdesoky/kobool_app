import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/router_provider.dart';
import 'package:kobool/providers/settings_provider.dart';

class KAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const KAppBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    String routeName = ref.watch(routerProvider).name.replaceAll("/", "");
    final themeMode = ref.watch(themeModeProvider);
    return AppBar(
      title: Text("Kobool - $routeName"),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      actions: [
        IconButton(
          icon: Icon(
            themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
          ),
          onPressed: () {
            ref.read(themeModeProvider.notifier).state = themeMode.next();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

extension on ThemeMode {
  ThemeMode next() {
    if (this == ThemeMode.system) {
      return ThemeMode.light;
    } else if (this == ThemeMode.light) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.system;
    }
  }
}
