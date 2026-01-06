import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/utils/user_attr.dart';

class UserAttr {
  static const id = "id";
  static const loginName = "login_id";
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
  final double picSize;
  const UserAttrButton({
    super.key,
    required this.attr,
    required this.props,
    this.picSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final pageArgs =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
        {};
    final colorScheme = Theme.of(context).colorScheme;
    final gender = props[UserAttr.gender].toString();
    final isMale = gender == "0";
    final genderColor = isMale ? Colors.blue : Colors.pink;
    final genderIcon = isMale ? Icons.male : Icons.female;
    final genderPic = isMale ? Icons.person : Icons.person_2;
    final id = props[UserAttr.id]!.toString();
    // final pic = props[UserAttr.pic]?.toString() ?? "0";
    final child = switch (attr) {
      UserAttr.loginName => Text(
        props[UserAttr.loginName].toString(),
        overflow: TextOverflow.ellipsis,
      ),
      // UserAttr.pic => Image.network(
      //   Uri.parse(API.pic)
      //       .replace(queryParameters: {"g": gender, "id": pic, "tn": "1"})
      //       .toString(),
      //   width: picSize,
      // ),
      UserAttr.pic => Icon(genderPic, color: genderColor, size: picSize),
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
        Navigator.pushNamed(context, Routes.user, arguments: id);
      },
      UserAttr.loginName => () {
        Navigator.pushNamed(context, Routes.user, arguments: id);
      },
      UserAttr.gender =>
        pageArgs.containsKey('g')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.results,
                  arguments: {...pageArgs, 'g': props[UserAttr.gender]},
                );
              },
      UserAttr.age =>
        pageArgs.containsKey('ag')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.results,
                  arguments: {
                    ...pageArgs,
                    'ag':
                        "${int.parse(props["birth_year"].toString()) - 2}-${int.parse(props["birth_year"].toString()) + 2}",
                  },
                );
              },
      UserAttr.maritalStatus =>
        pageArgs.containsKey('ms')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.results,
                  arguments: {...pageArgs, 'ms': props[UserAttr.maritalStatus]},
                );
              },
      UserAttr.country =>
        pageArgs.containsKey('c')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.results,
                  arguments: {...pageArgs, 'c': props[UserAttr.country]},
                );
              },
      UserAttr.origin =>
        pageArgs.containsKey('o')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.results,
                  arguments: {...pageArgs, 'o': props[UserAttr.origin]},
                );
              },
      _ => () {},
    };

    final double elevation = switch (attr) {
      UserAttr.pic => 0,
      UserAttr.loginName => 0,
      _ => 1,
    };
    final backgroundColor = switch (attr) {
      UserAttr.pic => colorScheme.surfaceContainerLow,
      UserAttr.loginName => colorScheme.surfaceContainerLow,
      _ => colorScheme.surface,
    };

    return child != null
        ? Tooltip(
            message: "More information",
            waitDuration: Duration(milliseconds: 500), // Delay before showing
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
                alignment: AlignmentDirectional.centerStart,
              ),
              child: child,
            ),
          )
        : const SizedBox.shrink();
  }
}
