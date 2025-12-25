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
      width: 220,
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
            leading: Icon(Icons.home),
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
            leading: Icon(Icons.login),
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
            leading: Icon(Icons.search),
            title: Text('Search'),
            selected: routerState.name == Routes.search,
            selectedTileColor: colorScheme.surfaceContainerHighest,
            onTap: () {
              // Handle settings tap
              navigatorKey.currentState?.pushNamed(Routes.search);
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Online members'),
            selected: routerState.name == Routes.results,
            selectedTileColor: colorScheme.surfaceContainerHighest,
            onTap: () {
              // Handle login tap
              navigatorKey.currentState?.pushNamed(Routes.results);
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.forum),
            title: Text('QA Forum'),
            selected: routerState.name == Routes.forum,
            selectedTileColor: colorScheme.surfaceContainerHighest,
            onTap: () {
              // Handle login tap
              navigatorKey.currentState?.pushNamed(Routes.forum);
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contact Us'),
            selected: routerState.name == Routes.contact,
            selectedTileColor: colorScheme.surfaceContainerHighest,
            onTap: () {
              // Handle settings tap
              navigatorKey.currentState?.pushNamed(Routes.contact);
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language'),
            onTap: () {
              // Handle settings tap
              // confirm dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Language'),
                  content: Text('Change language?'),
                  actions: [
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        // change language
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          // Add more ListTile widgets for additional drawer items
        ],
      ),
    );
  }
}
