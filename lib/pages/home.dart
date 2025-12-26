import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kobool/utils/dialogs.dart';
import 'package:kobool/widgets/home_button.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(title: Text("home_title".tr())),
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
                        label: "login".tr(),
                        icon: Icons.login,
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                      HomeButton(
                        label: "register".tr(),
                        icon: Icons.person_add,
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                      ),
                      HomeButton(
                        label: "search".tr(),
                        icon: Icons.search,
                        onPressed: () {
                          Navigator.pushNamed(context, '/search');
                        },
                      ),
                      HomeButton(
                        label: "members".tr(),
                        icon: Icons.people,
                        onPressed: () {
                          Navigator.pushNamed(context, '/results');
                        },
                      ),
                      HomeButton(
                        label: "forum".tr(),
                        icon: Icons.forum,
                        onPressed: () {
                          Navigator.pushNamed(context, '/forum');
                        },
                      ),
                      HomeButton(
                        label: "contact".tr(),
                        icon: Icons.contact_mail,
                        onPressed: () {
                          Navigator.pushNamed(context, '/contact');
                        },
                      ),
                      HomeButton(
                        label: "language".tr(),
                        icon: Icons.language,
                        onPressed: () {
                          showLanguageDialog(context, ref);
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
