import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kobool/consts/routes.dart';
import 'package:kobool/utils/context_extenstion.dart';
import 'package:kobool/utils/user_attr.dart';

class UserAttrButton extends StatelessWidget {
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
    final pageArgs = context.args;
    final gender = props[UserAttribute.gender].toString();
    final isMale = gender == "0";
    final genderColor = isMale ? Colors.blue : Colors.pink;
    final genderIcon = isMale ? Icons.male : Icons.female;
    final genderPic = isMale ? Icons.person : Icons.person_3;
    final id = props[UserAttribute.id]!.toString();
    // final pic = props[UserAttr.pic]?.toString() ?? "0";

    void navigateToFilter(key, value) {
      final newArgs = Map<String, dynamic>.from(pageArgs)
        ..remove(SearchFilter.id)
        ..addAll({key: value});

      Navigator.pushNamed(
        context,
        key == SearchFilter.id ? Routes.user : context.resultsRoute,
        arguments: newArgs,
      );
    }

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
      UserAttribute.gender => Icon(genderIcon, color: genderColor, size: 20),
      UserAttribute.age =>
        props[UserAttribute.age] != null
            ? Text("age_value".tr(args: [props[UserAttribute.age].toString()]))
            : null,
      UserAttribute.maritalStatus => renderMaterialStatus(
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
        pageArgs.containsKey(SearchFilter.id)
            ? null
            : () {
                navigateToFilter(SearchFilter.id, id);
              },
      UserAttribute.loginName =>
        pageArgs.containsKey(SearchFilter.id)
            ? null
            : () {
                navigateToFilter(SearchFilter.id, id);
              },
      UserAttribute.gender =>
        pageArgs.containsKey(SearchFilter.gender)
            ? null
            : () {
                navigateToFilter(
                  SearchFilter.gender,
                  props[UserAttribute.gender],
                );
              },
      UserAttribute.age =>
        pageArgs.containsKey(SearchFilter.age)
            ? null
            : () {
                navigateToFilter(
                  SearchFilter.age,
                  "${int.parse(props["birth_year"].toString()) - 2}-${int.parse(props["birth_year"].toString()) + 2}",
                );
              },
      UserAttribute.maritalStatus =>
        pageArgs.containsKey(SearchFilter.maritalStatus)
            ? null
            : () {
                navigateToFilter(
                  SearchFilter.maritalStatus,
                  props[UserAttribute.maritalStatus],
                );
              },
      UserAttribute.country =>
        pageArgs.containsKey(SearchFilter.country)
            ? null
            : () {
                navigateToFilter(
                  SearchFilter.country,
                  props[UserAttribute.country],
                );
              },
      UserAttribute.origin =>
        pageArgs.containsKey(SearchFilter.origin)
            ? null
            : () {
                navigateToFilter(
                  SearchFilter.origin,
                  props[UserAttribute.origin],
                );
              },
      _ => () {},
    };

    // final double elevation = switch (attr) {
    //   UserAttribute.pic => 0,
    //   UserAttribute.loginName => 0,
    //   _ => 1,
    // };
    // final backgroundColor = switch (attr) {
    //   UserAttribute.pic => colorScheme.surfaceContainerLow,
    //   UserAttribute.loginName => colorScheme.surfaceContainerLow,
    //   _ => colorScheme.surface,
    // };

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
