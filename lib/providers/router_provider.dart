import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/consts/routes.dart';

// State class for router
class RouterState {
  final String name;
  final Object? params;

  const RouterState({required this.name, this.params});

  RouterState copyWith({String? name, Object? params}) {
    return RouterState(name: name ?? this.name, params: params ?? this.params);
  }

  static const initial = RouterState(name: Routes.home);
}

// StateNotifier for router
class RouterNotifier extends Notifier<RouterState> {
  // RouterNotifier() : super(RouterState.initial);
  @override
  RouterState build() {
    return RouterState.initial;
  }

  // Update current route
  void updateRoute(String? name, Object? params) {
    state = state.copyWith(name: name ?? state.name, params: params);
  }
}

// Provider for router
final routerProvider = NotifierProvider<RouterNotifier, RouterState>(
  RouterNotifier.new,
);
