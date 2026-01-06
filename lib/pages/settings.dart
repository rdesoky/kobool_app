import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/locale_provider.dart';
import 'package:kobool/providers/theme_mode_provider.dart';
import 'package:kobool/widgets/home_button.dart';
import 'package:kobool/widgets/settings.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text("settings".tr())),
      body: SingleChildScrollView(child: Center(child: Settings())),
    );
  }
}
