// filepath: lib/app_route_observer.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/router_provider.dart';

class AppRouteObserver extends RouteObserver<ModalRoute<void>> {
  final WidgetRef ref;

  AppRouteObserver(this.ref);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      Future(() {
        ref
            .read(routerProvider.notifier)
            .updateRoute(route.settings.name, route.settings.arguments);
      });
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute?.settings != null) {
      Future(() {
        ref
            .read(routerProvider.notifier)
            .updateRoute(
              previousRoute!.settings.name,
              previousRoute.settings.arguments,
            );
      });
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute?.settings != null) {
      Future(() {
        ref
            .read(routerProvider.notifier)
            .updateRoute(newRoute!.settings.name, newRoute.settings.arguments);
      });
    }
  }
}
