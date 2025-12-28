import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/providers/locale_provider.dart';
import 'package:kobool/providers/user_session_provider.dart';

void showLanguageDialog(BuildContext context, WidgetRef ref) {
  void onChangeLanguage() {
    //toggle between ar and en
    final updatedLocale = ref.read(localeProvider) == 'ar' ? 'en' : 'ar';

    ref.read(localeProvider.notifier).state = updatedLocale;
    context.setLocale(
      Locale(updatedLocale),
    ); // update context locale ( presists in shared preferences "locale" string)
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

void confirmLogoutDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('logout'.tr()),
      content: Text("${'are_you_sure'.tr()} ?"),
      actions: [
        TextButton(
          child: Text('cancel'.tr()),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('ok'.tr()),
          onPressed: () {
            ref
                .read(userSessionProvider.notifier)
                .setUserSession(UserSession());
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
