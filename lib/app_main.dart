import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/app_route_observer.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/router_provider.dart';
import 'package:kobool/route_generator.dart';

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
      home: const _AppScaffold(key: ValueKey("AppScaffold")),
    );
  }
}

class _AppScaffold extends ConsumerWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static AppRouteObserver? _appRouteObserver;

  const _AppScaffold({super.key});

  @override
  Widget build(BuildContext context, ref) {
    _appRouteObserver ??= AppRouteObserver(ref);
    String routeName = ref.watch(routerProvider).name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Kobool$routeName"),
      ),
      body: Navigator(
        key: navigatorKey,
        initialRoute: Routes.home,
        onGenerateRoute: RouteGenerator.generateRoute,
        observers: [_appRouteObserver!],
      ),
    );
  }
}
