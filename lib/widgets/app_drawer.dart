import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/router_provider.dart';
import 'package:kobool/providers/user_session_provider.dart';

class AppDrawer extends ConsumerWidget {
  final bool showHeader;
  final GlobalKey<NavigatorState> navigatorKey;

  const AppDrawer({
    super.key,
    this.showHeader = true,
    required this.navigatorKey,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final routerState = ref.watch(routerProvider);
    final isLoggedIn = ref.watch(userSessionProvider).isLoggedIn();

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: colorScheme.surfaceContainer,
      width: 200,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (showHeader)
            SizedBox(
              height: 64,
              child: DrawerHeader(
                decoration: BoxDecoration(color: colorScheme.surfaceDim),
                child: Text('Kobool'),
              ),
            ),
          ...[
            (Icons.home, Routes.home, 'home'),
            if (!isLoggedIn) (Icons.login, Routes.login, 'login'),
            (Icons.search, Routes.search, 'search'),
            (Icons.people, Routes.results, 'members'),
            (Icons.forum, Routes.forum, 'forum'),
            (Icons.contact_mail, Routes.contact, 'contact'),
          ].map(
            (item) => ListTile(
              leading: Icon(item.$1),
              title: Text(item.$3.tr()),
              selected: routerState.name == item.$2,
              selectedTileColor: colorScheme.surfaceContainerHighest,
              onTap: routerState.name == item.$2
                  ? null
                  : () {
                      navigatorKey.currentState?.pushNamed(item.$2);
                      Scaffold.of(context).closeDrawer();
                    },
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('settings'.tr()),
            selected: routerState.name == Routes.settings,
            selectedTileColor: colorScheme.surfaceContainerHighest,
            onTap: routerState.name == Routes.settings
                ? null
                : () {
                    navigatorKey.currentState?.pushNamed(Routes.settings);
                    Scaffold.of(context).closeDrawer();
                  },
          ),
        ],
      ),
    );
  }
}
