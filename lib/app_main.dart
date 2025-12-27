import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/app_route_observer.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/locale_provider.dart';
import 'package:kobool/providers/main_app_bar_provider.dart';
import 'package:kobool/providers/theme_mode_provider.dart';
import 'package:kobool/route_generator.dart';
import 'package:kobool/widgets/app_drawer.dart';
import 'package:kobool/widgets/kb_app_bar.dart';

class AppMain extends ConsumerWidget {
  const AppMain({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    if (locale != null) {
      context.setLocale(Locale(locale));
    }
    return MaterialApp(
      title: 'KOBOOL - first step to marriage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: locale != null ? Locale(locale) : null,
      home: _AppScaffold(
        key: ValueKey("AppScaffold"),
        navigatorKey: navigatorKey,
      ),
    );
  }
}

class _AppScaffold extends HookConsumerWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const _AppScaffold({super.key, required this.navigatorKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useInitApp(ref);

    final isWideView = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: ref.watch(mainAppBarProvider) ? KbAppBar() : null,
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

void useInitApp(WidgetRef ref) {
  // final themeMode = ref.watch(themeModeProvider);

  useEffect(() {
    // providers initialization
    // read themMode from shared preferences
    // SharedPreferences.getInstance().then((prefs) {
    // final themeMode = prefs.getString('themeMode');
    // if (themeMode == null) {
    //   return; //initial value
    // }
    // //dispatch/setState initial themeMode from shared preferences
    // ref
    //     .read(themeModeProvider.notifier)
    //     .setThemeMode(themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light);

    // dispatch/setState initial language from shared preferences
    // final locale = prefs.getString('locale');
    // if (locale != null) {
    //   //dispatch/setState
    //   ref.read(localeProvider.notifier).state = locale;
    // }
    // });

    return null;
  }, []);

  // useEffect(() {
  //   if (themeMode == ThemeMode.system) {
  //     return; //initial value
  //   }
  //   //updated value
  //   SharedPreferences.getInstance().then((prefs) {
  //     prefs.setString('themeMode', themeMode.name);
  //   });
  //   return null;
  // }, [themeMode]);
}
