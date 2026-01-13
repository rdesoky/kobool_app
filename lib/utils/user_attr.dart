import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/providers/countries_provider.dart';

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

Widget renderMaritalStatus(BuildContext context, dynamic status) {
  return maritalStatus(context, status) ?? Text("unknown".tr());
}

String ageRangeToQueryParam(String ageRange) {
  final parts = ageRange.split('-');
  final fromAge = int.parse(parts[0]);
  final fromBirthYear = DateTime.now().year - fromAge;
  final toAge = int.parse(parts[1]);
  final toBirthYear = DateTime.now().year - toAge;

  return '$toBirthYear-$fromBirthYear';
}

class SearchFilter {
  static const gender = "g"; // g
  static const age = "ag"; // ag
  static const maritalStatus = "ms"; // ms
  static const children = "ch"; // ch
  static const country = "c"; // c
  static const state = "st"; // st
  static const city = "ci"; // ci
  static const origin = "o"; // o
  static const height = "ht"; // ht
  static const weight = "wt"; // wt
  static const job = "jb"; // jb
  static const income = "nc"; // nc
  static const language = "la"; //la
  static const race = "rc"; // rc
  static const education = "ed"; // ed
  static const smoke = "sm"; // sm
  static const religion = "re"; // re
  static const disability = "ds"; // ds
  static const dress = "dt"; // dt
  static const shape = "sh"; // sh
  static const face = "fc"; // fc
  static const district = "dst"; //dst
  static const polygamy = "po"; // po
}

class UserAttribute {
  static const id = "id";
  static const loginName = "login_id";
  static const pic = "main_pic";

  static const gender = "gender";
  static const age = "age";
  static const maritalStatus = "marital_status";
  static const children = "children";
  static const country = "country";
  static const state = "state";
  static const city = "city";
  static const origin = "origin";
  static const height = "height";
  static const weight = "weight";
  static const job = "job";
  static const income = "income";
  static const language = "language";
  static const race = "race";
  static const education = "education";
  static const smoke = "smoke";
  static const religion = "religion";
  static const disability = "disability";
  static const dress = "dress";
  static const shape = "shape";
  static const face = "face";
  static const district = "district";
  static const polygamy = "polygamy";
}

class FilterInfo {
  final String attr;
  final String title;
  final IconData icon;
  final Map<dynamic, dynamic> Function(WidgetRef ref)? options;
  FilterInfo({
    required this.attr,
    required this.title,
    required this.icon,
    this.options,
  });
  String mapValue(WidgetRef ref, dynamic value) {
    final String val = options!(ref)[value.toString()] ?? value.toString();
    return val.tr();
  }
}

final Map<String, FilterInfo> gFilters = {
  SearchFilter.gender: FilterInfo(
    attr: UserAttribute.gender,
    title: "gender",
    icon: Icons.male,
    options: (ref) {
      return {"0": "male".tr(), "1": "female".tr()};
    },
  ),
  SearchFilter.age: FilterInfo(
    attr: UserAttribute.age,
    title: "age",
    icon: Icons.hourglass_bottom,
    options: (ref) {
      return {
        "1": "18-24",
        "2": "25-29",
        "3": "30-34",
        "4": "35-39",
        "5": "40-44",
        "6": "45-49",
        "7": "50-54",
        "8": "55-59",
        "9": "60-64",
        "10": "65-69",
        "11": "70-74",
        "12": "75-79",
        "13": "80-84",
        "14": "85-89",
        "15": "90-94",
        "16": "95-99",
        "17": "100+",
      };
    },
  ),
  SearchFilter.height: FilterInfo(
    attr: "height",
    title: "height",
    icon: Icons.height,
    options: (ref) => {},
  ),
  SearchFilter.weight: FilterInfo(
    attr: "weight",
    title: "weight",
    icon: Icons.scale,
    options: (ref) => {},
  ),
  SearchFilter.smoke: FilterInfo(
    attr: "smoke",
    title: "smoke",
    icon: Icons.smoke_free,
    options: (ref) => {},
  ),
  SearchFilter.maritalStatus: FilterInfo(
    attr: UserAttribute.maritalStatus,
    title: "marital_status",
    icon: Icons.family_restroom,
    options: (ref) {
      return {
        "1": "single",
        "2": "divorced",
        "3": "widow",
        "4": "separated",
        "5": "married",
        "6": "engaged",
      };
    },
  ),
  SearchFilter.country: FilterInfo(
    attr: UserAttribute.country,
    title: "country",
    icon: Icons.map,
    options: (ref) {
      final countries = ref.read(countriesProvider.notifier).countries;
      return countries;
    },
  ),
  SearchFilter.origin: FilterInfo(
    attr: UserAttribute.origin,
    title: "origin",
    icon: Icons.map,
    options: (ref) {
      final countries = ref.read(countriesProvider.notifier).countries;
      return countries;
    },
  ),
  SearchFilter.race: FilterInfo(
    attr: UserAttribute.race,
    title: "race",
    icon: Icons.map,
    options: (ref) => {},
  ),
  SearchFilter.religion: FilterInfo(
    attr: UserAttribute.religion,
    title: "religion",
    icon: Icons.mosque,
    options: (ref) {
      return {
        "1": "muslim".tr(),
        "2": "christian".tr(),
        "3": "hindu".tr(),
        "4": "buddhist".tr(),
        "5": "other".tr(),
      };
    },
  ),
  SearchFilter.disability: FilterInfo(
    attr: UserAttribute.disability,
    title: "disability",
    icon: Icons.mosque,
    options: (ref) {
      return {"1": "yes".tr(), "2": "no".tr()};
    },
  ),
  SearchFilter.dress: FilterInfo(
    attr: UserAttribute.dress,
    title: "dress",
    icon: Icons.mosque,
    options: (ref) {
      return {"1": "yes".tr(), "2": "no".tr()};
    },
  ),
  SearchFilter.shape: FilterInfo(
    attr: UserAttribute.shape,
    title: "shape",
    icon: Icons.mosque,
    options: (ref) {
      return {"1": "yes".tr(), "2": "no".tr()};
    },
  ),
  SearchFilter.face: FilterInfo(
    attr: UserAttribute.face,
    title: "face",
    icon: Icons.face_2,
    options: (ref) {
      return {"1": "yes".tr(), "2": "no".tr()};
    },
  ),
  SearchFilter.district: FilterInfo(
    attr: UserAttribute.district,
    title: "district",
    icon: Icons.mosque,
    options: (ref) {
      return {"1": "yes".tr(), "2": "no".tr()};
    },
  ),
  SearchFilter.polygamy: FilterInfo(
    attr: UserAttribute.polygamy,
    title: "polygamy",
    icon: Icons.mosque,
    options: (ref) {
      return {"1": "yes".tr(), "2": "no".tr()};
    },
  ),
};
