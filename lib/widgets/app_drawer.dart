import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/router_provider.dart';
import 'package:kobool/providers/user_session_provider.dart';
import 'package:kobool/utils/context_extenstion.dart';
import 'package:kobool/widgets/settings.dart';

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
    final colorScheme = context.colorScheme;
    final routerState = ref.watch(routerProvider);
    final isLoggedIn = ref.watch(userSessionProvider).isLoggedIn();

    void navigateTo(String route) {
      if (routerState.name == route) {
        return; //same route
      }
      navigatorKey.currentState?.popUntil(
        (route) => route.isFirst,
      ); // go to home
      if (route != Routes.home) {
        navigatorKey.currentState?.pushNamed(route); // push new route
      }
      Scaffold.of(context).closeDrawer();
    }

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
            (Icons.person_search, Routes.drill, 'drill'),
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
                      navigateTo(item.$2);
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
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Settings(),
                    );
                    // navigatorKey.currentState?.pushNamed(Routes.settings);
                    Scaffold.of(context).closeDrawer();
                  },
          ),
        ],
      ),
    );
  }
}
