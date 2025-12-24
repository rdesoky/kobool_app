import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/router_provider.dart';

class AppDrawer extends ConsumerWidget {
  final bool showHeader;
  final GlobalKey<NavigatorState> navigatorKey;

  const AppDrawer({
    super.key,
    this.showHeader = true,
    required this.navigatorKey,
  });
  @override
  Widget build(BuildContext context, ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final routerState = ref.watch(routerProvider);

    return Drawer(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: colorScheme.surfaceContainer,
      width: 240,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          if (showHeader)
            SizedBox(
              height: 120,
              child: DrawerHeader(
                decoration: BoxDecoration(color: colorScheme.surfaceDim),
                child: Text('Kobool'),
              ),
            ),
          ListTile(
            selected: routerState.name == Routes.home,
            selectedTileColor: colorScheme.surfaceContainerHighest,
            title: Text('Home'),
            onTap: () {
              // Handle home tap
              navigatorKey.currentState?.popUntil((route) => route.isFirst);
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Text('Login'),
            selected: routerState.name == Routes.login,
            selectedTileColor: colorScheme.surfaceContainerHighest,
            onTap: () {
              // Handle login tap
              navigatorKey.currentState?.pushNamed(Routes.login);
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            title: Text('Online members'),
            selected: routerState.name == Routes.results,
            selectedTileColor: colorScheme.surfaceContainerHighest,
            onTap: () {
              // Handle login tap
              navigatorKey.currentState?.pushNamed(Routes.results);
              Scaffold.of(context).closeDrawer();
            },
          ),
          // Add more ListTile widgets for additional drawer items
        ],
      ),
    );
  }
}
