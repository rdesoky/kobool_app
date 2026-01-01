import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/app_main.dart';
import 'package:kobool/providers/locale_provider.dart';
import 'package:kobool/providers/router_provider.dart';
import 'package:kobool/providers/theme_mode_provider.dart';
import 'package:kobool/utils/misc.dart';

class KbAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const KbAppBar({super.key});

  @override
  Widget build(BuildContext context, ref) {
    String routeName = ref.watch(routerProvider).name;
    final brightness = Theme.of(context).brightness;
    final language = ref.watch(localeProvider);
    final isWideView = MediaQuery.of(context).size.width > 600;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Row(
        spacing: 12,
        children: [
          if (language != null)
            IconButton(
              onPressed: () {
                AppMain.navigatorKey.currentState?.popUntil(
                  (route) => route.isFirst,
                );
              },
              icon: Image.asset(
                "assets/images/$language/kobool.png",
                height: 40,
              ),
            ),
          if (!isWideView) routeIcon(routeName),
        ],
      ),
      backgroundColor: colorScheme.primaryContainer,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8),
      actions: [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
