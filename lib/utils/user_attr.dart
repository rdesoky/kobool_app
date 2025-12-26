import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

Widget? maritalStatus(BuildContext context, dynamic status) {
  switch (status.toString()) {
    case "1":
      return Text("single".tr());
    case "2":
      return Text("divorced".tr());
    case "3":
      return Text("widow".tr());
    case "4":
      return Text("separated".tr());
    case "5":
      return Text("married".tr());
    case "6":
      return Text("engaged".tr());
    default:
      return null;
  }
}
