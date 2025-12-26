import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/router_provider.dart';
import 'package:kobool/providers/settings_provider.dart';

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
            title: Text('home'.tr()),
            onTap: () {
              // Handle home tap
              navigatorKey.currentState?.popUntil((route) => route.isFirst);
              Scaffold.of(context).closeDrawer();
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('login'.tr()),
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
            title: Text('search'.tr()),
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
            title: Text('members'.tr()),
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
            title: Text('forum'.tr()),
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
            title: Text('contact'.tr()),
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
            title: Text('language'.tr()),
            onTap: () {
              // Handle settings tap
              // confirm dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('language'.tr()),
                  content: Text("${'change_language'.tr()} ?"),
                  actions: [
                    TextButton(
                      child: Text('cancel'.tr()),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: Text('ok'.tr()),
                      onPressed: () {
                        // change language
                        final newLanguage = ref.read(languageProvider) == 'ar'
                            ? 'en'
                            : 'ar';

                        //useInitApp effect will update the shared preferences
                        ref.read(languageProvider.notifier).state = newLanguage;
                        context.setLocale(Locale(newLanguage));
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
