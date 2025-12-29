import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/providers/user_session_provider.dart';
import 'package:kobool/utils/dialogs.dart';
import 'package:kobool/widgets/home_button.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final userSession = ref.watch(userSessionProvider);
    final isLoggedIn = userSession.isLoggedIn();

    return Scaffold(
      appBar: AppBar(
        title: Text("home_title".tr(args: [userSession.loginId ?? ""])),
      ),
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
                      if (isLoggedIn)
                        ...[
                          (
                            "visitors".tr(),
                            Icons.people,
                            () {
                              Navigator.pushNamed(
                                context,
                                Routes.results,
                                arguments: {"ls": "vtr"},
                              );
                            },
                          ),
                          (
                            "visited".tr(),
                            Icons.history,
                            () {
                              Navigator.pushNamed(
                                context,
                                Routes.results,
                                arguments: {"ls": "vtd"},
                              );
                            },
                          ),

                          (
                            "wishlist".tr(),
                            Icons.favorite,
                            () {
                              Navigator.pushNamed(
                                context,
                                Routes.results,
                                arguments: {"ls": "wls"},
                              );
                            },
                          ),
                          (
                            "wishers".tr(),
                            Icons.favorite_border,
                            () {
                              Navigator.pushNamed(
                                context,
                                Routes.results,
                                arguments: {"ls": "wsr"},
                              );
                            },
                          ),
                          (
                            "bookmarks".tr(),
                            Icons.bookmark,
                            () {
                              Navigator.pushNamed(
                                context,
                                Routes.results,
                                arguments: {"ls": "bkm"},
                              );
                            },
                          ),
                          (
                            "blocked".tr(),
                            Icons.not_interested,
                            () {
                              Navigator.pushNamed(
                                context,
                                Routes.results,
                                arguments: {"ls": "blk"},
                              );
                            },
                          ),
                          (
                            "logout".tr(),
                            Icons.logout,
                            () {
                              confirmLogoutDialog(context, ref);
                            },
                          ),
                        ].map(
                          (item) => HomeButton(
                            label: item.$1,
                            icon: item.$2,
                            onPressed: item.$3,
                          ),
                        ),
                      if (!isLoggedIn)
                        ...[
                          ("login".tr(), Icons.login, Routes.login),
                          ("register".tr(), Icons.person_add, Routes.register),
                          ("members".tr(), Icons.people, Routes.results),
                        ].map(
                          (item) => HomeButton(
                            label: item.$1,
                            icon: item.$2,
                            onPressed: () =>
                                Navigator.pushNamed(context, item.$3),
                          ),
                        ),
                      ...[
                        ("search".tr(), Icons.search, Routes.search, null),
                        ("forum".tr(), Icons.forum, Routes.forum, null),
                        (
                          "contact".tr(),
                          Icons.contact_mail,
                          Routes.contact,
                          null,
                        ),
                        (
                          "language".tr(),
                          Icons.language,
                          null,
                          () => showLanguageDialog(context, ref),
                        ),
                      ].map(
                        (item) => HomeButton(
                          label: item.$1,
                          icon: item.$2,
                          onPressed: item.$4 != null
                              ? item.$4!
                              : item.$3 != null
                              ? () => Navigator.pushNamed(context, item.$3!)
                              : null,
                        ),
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
