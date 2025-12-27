import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/settings_provider.dart';

void showLanguageDialog(BuildContext context, WidgetRef ref) {
  void onChangeLanguage() {
    final newLanguage = ref.read(languageProvider) == 'ar' ? 'en' : 'ar';

    //useInitApp effect will update the shared preferences
    ref.read(languageProvider.notifier).state = newLanguage;
    context.setLocale(Locale(newLanguage));
  }

  // showDialog(
  //   context: context,
  //   builder: (context) => AlertDialog(
  //     title: Text('language'.tr()),
  //     content: Text("${'change_language'.tr()} ?"),
  //     actions: [
  //       TextButton(
  //         child: Text('cancel'.tr()),
  //         onPressed: () => Navigator.pop(context),
  //       ),
  //       TextButton(
  //         child: Text('ok'.tr()),
  //         onPressed: () {
  //           onChangeLanguage();
  //           Navigator.pop(context);
  //         },
  //       ),
  //     ],
  //   ),
  // );
  onChangeLanguage();
}
