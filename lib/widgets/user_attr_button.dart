import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/utils/user_attr.dart';

class UserAttr {
  static const pic = "main_pic";
  static const gender = "gender";
  static const age = "age";
  static const maritalStatus = "marital_status";
  static const country = "country";
  static const origin = "origin_country";
  static const state = "state";
  static const children = "children";
}

class UserAttrButton extends HookWidget {
  final String attr;
  final Map<String, dynamic> props;
  const UserAttrButton({super.key, required this.attr, required this.props});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMale = props[UserAttr.gender] == "0";
    final genderColor = isMale ? Colors.blue : Colors.pink;
    final genderIcon = isMale ? Icons.male : Icons.female;
    final child = switch (attr) {
      UserAttr.pic => Icon(Icons.person, color: genderColor, size: 48),
      UserAttr.gender => Icon(genderIcon, color: genderColor),
      UserAttr.age =>
        props[UserAttr.age] != null
            ? Text("age_value".tr(args: [props[UserAttr.age].toString()]))
            : null,
      UserAttr.maritalStatus => maritalStatus(
        context,
        props[UserAttr.maritalStatus],
      ),
      UserAttr.country =>
        props[UserAttr.country] != null
            ? Text("countries.${props[UserAttr.country]}".tr())
            : null,
      UserAttr.origin =>
        props[UserAttr.origin] != null &&
                props[UserAttr.origin] != props[UserAttr.country]
            ? Text(
                "${"nationality".tr()}: ${"countries.${props[UserAttr.origin]}".tr()}",
              )
            : null,
      _ => null,
    };
    final onPressed = switch (attr) {
      UserAttr.pic => () {
        Navigator.pushNamed(context, Routes.user, arguments: props['id']);
      },
      UserAttr.gender => () {
        Navigator.pushNamed(context, Routes.results);
      },
      UserAttr.age => () {
        Navigator.pushNamed(context, Routes.results);
      },
      UserAttr.maritalStatus => () {
        Navigator.pushNamed(context, Routes.results);
      },
      _ => () {},
    };

    final double elevation = switch (attr) {
      UserAttr.pic => 0,
      _ => 1,
    };
    final backgroundColor = switch (attr) {
      UserAttr.pic => colorScheme.surfaceContainerLow,
      _ => colorScheme.surface,
    };

    return child != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 4.0, right: 6.0),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(24, 38),
                backgroundColor: backgroundColor,
                elevation: elevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 4.0,
                ),
              ),
              child: child,
            ),
          )
        : const SizedBox.shrink();
  }
}
