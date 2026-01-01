import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/locale_provider.dart';
import 'package:kobool/providers/theme_mode_provider.dart';
import 'package:kobool/widgets/home_button.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text("settings".tr())),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 600,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      HomeButton(
                        label: "language".tr(),
                        icon: Icons.language,
                        onPressed: () {
                          // Toggle between ar and en
                          final updatedLocale = currentLocale == 'ar'
                              ? 'en'
                              : 'ar';
                          ref
                              .read(localeProvider.notifier)
                              .setLocale(updatedLocale);
                          context.setLocale(Locale(updatedLocale));
                        },
                      ),
                      HomeButton(
                        label: currentThemeMode == ThemeMode.dark
                            ? "light_theme".tr()
                            : "dark_theme".tr(),
                        icon: currentThemeMode == ThemeMode.dark
                            ? Icons.light_mode
                            : Icons.dark_mode,
                        onPressed: () {
                          // Toggle between light and dark theme
                          final newThemeMode =
                              currentThemeMode == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                          ref
                              .read(themeModeProvider.notifier)
                              .setThemeMode(newThemeMode);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
