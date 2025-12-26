import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/router_provider.dart';
import 'package:kobool/providers/settings_provider.dart';
import 'package:kobool/utils/misc.dart';

class KbAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const KbAppBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    String routeName = ref.watch(routerProvider).name;
    final brightness = Theme.of(context).brightness;
    final language = ref.watch(languageProvider);
    return AppBar(
      title: Row(
        spacing: 12,
        children: [
          if (language != null)
            Image.asset("assets/images/$language/kobool.png", height: 40),
          routeIcon(routeName),
        ],
      ),
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
