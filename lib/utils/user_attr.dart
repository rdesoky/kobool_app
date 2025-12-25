import 'package:flutter/material.dart';

Widget? maritalStatus(BuildContext context, dynamic status) {
  switch (status.toString()) {
    case "1":
      return const Text("Single");
    case "2":
      return const Text("Divorced");
    case "3":
      return const Text("Widow");
    case "4":
      return const Text("Separated");
    case "5":
      return const Text("Married");
    case "6":
      return const Text("Engaged");
    default:
      return null;
  }
}
