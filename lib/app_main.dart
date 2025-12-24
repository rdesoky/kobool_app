import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/app_route_observer.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/router_provider.dart';
import 'package:kobool/route_generator.dart';
import 'package:kobool/widgets/app_drawer.dart';
import 'package:kobool/widgets/kapp_bar.dart';

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kobool - first step to marriage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      themeMode: ThemeMode.light,
      home: _AppScaffold(key: ValueKey("AppScaffold")),
    );
  }
}

class _AppScaffold extends ConsumerWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const _AppScaffold({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isWideView = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: KAppBar(),
      drawer: isWideView ? null : AppDrawer(navigatorKey: navigatorKey),
      body: AppNavigator(navigatorKey: navigatorKey),
    );
  }
}

class AppNavigator extends ConsumerWidget {
  static AppRouteObserver? _appRouteObserver;
  final GlobalKey<NavigatorState> navigatorKey;

  const AppNavigator({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _appRouteObserver ??= AppRouteObserver(ref); //initialize observer only once
    final isWideView = MediaQuery.of(context).size.width > 600;
    final navigatorWidget = Navigator(
      key: navigatorKey,
      initialRoute: Routes.home,
      onGenerateRoute: RouteGenerator.generateRoute,
      observers: [_appRouteObserver!],
    );

    // Your implementation for the Pager widget
    return isWideView
        ? Row(
            children: [
              AppDrawer(showHeader: false, navigatorKey: navigatorKey),
              Expanded(child: navigatorWidget),
            ],
          )
        : navigatorWidget;
  }
}
