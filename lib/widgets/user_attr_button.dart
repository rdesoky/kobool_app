import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/utils/user_attr.dart';

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
    final gender = props[UserAttribute.gender].toString();
    final isMale = gender == "0";
    final genderColor = isMale ? Colors.blue : Colors.pink;
    final genderIcon = isMale ? Icons.male : Icons.female;
    final genderPic = isMale ? Icons.person : Icons.person_3;
    final id = props[UserAttribute.id]!.toString();
    // final pic = props[UserAttr.pic]?.toString() ?? "0";
    final child = switch (attr) {
      UserAttribute.loginName => Text(
        props[UserAttribute.loginName].toString(),
        overflow: TextOverflow.ellipsis,
      ),
      // UserAttr.pic => Image.network(
      //   Uri.parse(API.pic)
      //       .replace(queryParameters: {"g": gender, "id": pic, "tn": "1"})
      //       .toString(),
      //   width: picSize,
      // ),
      UserAttribute.pic => Icon(genderPic, color: genderColor, size: picSize),
      UserAttribute.gender => Icon(genderIcon, color: genderColor),
      UserAttribute.age =>
        props[UserAttribute.age] != null
            ? Text("age_value".tr(args: [props[UserAttribute.age].toString()]))
            : null,
      UserAttribute.maritalStatus => maritalStatus(
        context,
        props[UserAttribute.maritalStatus],
      ),
      UserAttribute.country =>
        props[UserAttribute.country] != null
            ? Text("countries.${props[UserAttribute.country]}".tr())
            : null,
      UserAttribute.origin =>
        props[UserAttribute.origin] != null &&
                props[UserAttribute.origin] != props[UserAttribute.country]
            ? Text(
                "${"nationality".tr()}: ${"countries.${props[UserAttribute.origin]}".tr()}",
              )
            : null,
      _ => null,
    };
    final onPressed = switch (attr) {
      UserAttribute.pic =>
        pageArgs.containsKey('id')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.user,
                  arguments: {...pageArgs, "id": id},
                );
              },
      UserAttribute.loginName =>
        pageArgs.containsKey('id')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.user,
                  arguments: {...pageArgs, "id": id},
                );
              },
      UserAttribute.gender =>
        pageArgs.containsKey('g')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.results,
                  arguments: {...pageArgs, 'g': props[UserAttribute.gender]},
                );
              },
      UserAttribute.age =>
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
      UserAttribute.maritalStatus =>
        pageArgs.containsKey('ms')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.results,
                  arguments: {
                    ...pageArgs,
                    'ms': props[UserAttribute.maritalStatus],
                  },
                );
              },
      UserAttribute.country =>
        pageArgs.containsKey('c')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.results,
                  arguments: {...pageArgs, 'c': props[UserAttribute.country]},
                );
              },
      UserAttribute.origin =>
        pageArgs.containsKey('o')
            ? null
            : () {
                Navigator.pushNamed(
                  context,
                  Routes.results,
                  arguments: {...pageArgs, 'o': props[UserAttribute.origin]},
                );
              },
      _ => () {},
    };

    final double elevation = switch (attr) {
      UserAttribute.pic => 0,
      UserAttribute.loginName => 0,
      _ => 1,
    };
    final backgroundColor = switch (attr) {
      UserAttribute.pic => colorScheme.surfaceContainerLow,
      UserAttribute.loginName => colorScheme.surfaceContainerLow,
      _ => colorScheme.surface,
    };

    return child != null
        ? Tooltip(
            message: onPressed != null ? "Press to add this filter" : "",
            waitDuration: Duration(milliseconds: 500), // Delay before showing
            child: ActionChip(
              onPressed: onPressed,

              // style: ElevatedButton.styleFrom(
              //   minimumSize: const Size(24, 38),
              //   backgroundColor: backgroundColor,
              //   elevation: elevation,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(2.0),
              //   ),
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 6.0,
              //     vertical: 4.0,
              //   ),
              //   alignment: AlignmentDirectional.centerStart,
              // ),
              label: child,
            ),
          )
        : const SizedBox.shrink();
  }
}
