import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kobool/providers/countries_provider.dart';

Widget? renderMaterialStatus(BuildContext context, dynamic status) {
  if (["0", null, 0].contains(status)) {
    return null;
  }
  final options = FilterInfo.fromFilter(SearchFilter.maritalStatus).options;
  return Text(options!(null)[status.toString()]!);
}

// Widget renderMaritalStatus(BuildContext context, dynamic status) {
//   return maritalStatus(context, status) ?? Text("unknown".tr());
// }

String ageRangeToQueryParam(String ageRange) {
  final parts = ageRange.split('-');
  final fromBirthYear = int.parse(parts[0]);
  final toBirthYear = int.parse(parts[1]);
  final currentYear = DateTime.now().year;
  final fromAge = currentYear - toBirthYear;
  final toAge = currentYear - fromBirthYear;

  return '$fromAge-$toAge';
}

class SearchFilter {
  static const id = "id";
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
  final Map<String, String> Function(WidgetRef? ref)? options;
  final String Function(WidgetRef? ref, dynamic value)? map;
  FilterInfo({
    required this.attr,
    required this.title,
    required this.icon,
    this.options,
    this.map,
  });
  String mapValue(WidgetRef ref, dynamic value) {
    if (map != null) {
      return map!(ref, value);
    }
    final String val = options!(ref)[value.toString()] ?? value.toString();
    return val.tr();
  }

  static FilterInfo fromFilter(String filter) {
    return gFilters[filter]!;
  }
}

final Map<String, FilterInfo> gFilters = {
  SearchFilter.gender: FilterInfo(
    attr: UserAttribute.gender,
    title: "gender",
    icon: Icons.male,
    options: (ref) => {"0": "husband".tr(), "1": "wife".tr()},
  ),
  SearchFilter.age: FilterInfo(
    attr: UserAttribute.age,
    title: "age",
    icon: Icons.hourglass_bottom,
    map: (ref, value) {
      return ageRangeToQueryParam(value);
    },
  ),
  SearchFilter.height: FilterInfo(
    attr: "height",
    title: "height",
    icon: Icons.height,
    options: (ref) => {
      "1": "4' 6\" (135 cm)".tr(),
      "2": "4' 7\" (138 cm)".tr(),
      "3": "4' 8\" (140 cm)".tr(),
      "4": "4' 9\" (143 cm)".tr(),
      "5": "4' 10\" (145 cm)".tr(),
      "6": "4' 11\" (148 cm)".tr(),
      "7": "5' (150 cm)".tr(),
      "8": "5' 1\" (153 cm)".tr(),
      "9": "5' 2\" (155 cm)".tr(),
      "10": "5' 3\" (158 cm)".tr(),
      "11": "5' 4\" (160 cm)".tr(),
      "12": "5' 5\" (163 cm)".tr(),
      "13": "5' 6\" (165 cm)".tr(),
      "14": "5' 7\" (168 cm)".tr(),
      "15": "5' 8\" (170 cm)".tr(),
      "16": "5' 9\" (173 cm)".tr(),
      "17": "5' 10\" (175 cm)".tr(),
      "18": "5' 11\" (178 cm)".tr(),
      "19": "6' (180 cm)".tr(),
      "20": "6' 1\" (183 cm)".tr(),
      "21": "6' 2\" (185 cm)".tr(),
      "22": "6' 3\" (188 cm)".tr(),
      "23": "6' 4\" (190 cm)".tr(),
      "24": "6' 5\" (193 cm)".tr(),
      "25": "6' 6\" (195 cm)".tr(),
      "26": "6' 7\" (198 cm)".tr(),
      "27": "6' 8\" (200 cm)".tr(),
      "28": "6' 9\" (203 cm)".tr(),
      "29": "6' 10\" (205 cm)".tr(),
      "30": "6' 11\" (208 cm)".tr(),

      "1-4": "from_135_to_143_cm".tr(),
      "5-9": "from_145_to_155_cm".tr(),
      "10-14": "from_158_to_168_cm".tr(),
      "15-19": "from_170_to_180_cm".tr(),
      "20-24": "from_183_to_193_cm".tr(),
      "25-29": "from_195_to_205_cm".tr(),
      "30-30": "over_208_cm".tr(),
    },
  ),
  SearchFilter.weight: FilterInfo(
    attr: "weight",
    title: "weight",
    icon: Icons.scale,
    options: (ref) {
      return {
        "1-4": "from_36_to_44_kg".tr(),
        "5-9": "from_45_to_56_kg".tr(),
        "10-14": "from_57_to_67_kg".tr(),
        "15-19": "from_68_to_78_kg".tr(),
        "20-24": "from_79_to_90_kg".tr(),
        "25-29": "from_91_to_101_kg".tr(),
        "30-34": "from_102_to_112_kg".tr(),
        "35-39": "from_113_to_124_kg".tr(),
        "40-41": "more_than_125_kg".tr(),
      };
    },
  ),
  SearchFilter.smoke: FilterInfo(
    attr: "smoke",
    title: "smoke",
    icon: Icons.smoke_free,
    options: (ref) => {
      "1": "no and it bothers me".tr(),
      "2": "no but it doesn't bother me".tr(),
      "3": "occasionally".tr(),
      "4": "frequently".tr(),
    },
  ),
  SearchFilter.maritalStatus: FilterInfo(
    attr: UserAttribute.maritalStatus,
    title: "marital_status",
    icon: Icons.family_restroom,
    options: (ref) => {
      "1": "single".tr(),
      "2": "divorced".tr(),
      "3": "widow".tr(),
      "4": "separated".tr(),
      "5": "married".tr(),
      "6": "engaged".tr(),
    },
  ),
  SearchFilter.children: FilterInfo(
    attr: UserAttribute.children,
    title: "children",
    icon: Icons.child_care,
    options: (ref) => {
      "1": "no children".tr(),
      "2": "children not living with me".tr(),
      "3": "children living with me".tr(),
    },
  ),

  SearchFilter.country: FilterInfo(
    attr: UserAttribute.country,
    title: "country",
    icon: Icons.public,
    options: (ref) {
      final countries = ref?.read(countriesProvider.notifier).countries;
      return countries ?? {};
    },
  ),
  SearchFilter.origin: FilterInfo(
    attr: UserAttribute.origin,
    title: "origin",
    icon: Icons.map,
    options: (ref) {
      final countries = ref?.read(countriesProvider.notifier).countries;
      return countries ?? {};
    },
  ),
  SearchFilter.language: FilterInfo(
    attr: UserAttribute.language,
    title: "language",
    icon: Icons.language,
    options: (ref) => {
      "1": "arabic".tr(),
      "2": "bengali".tr(),
      "3": "bahasa_melayu".tr(),
      "4": "bahasa_indonesia".tr(),
      "5": "chinese".tr(),
      "6": "dutch".tr(),
      "7": "english".tr(),
      "8": "french".tr(),
      "9": "german".tr(),
      "10": "italian".tr(),
      "11": "japanese".tr(),
      "12": "persian".tr(),
      "13": "punjabi".tr(),
      "14": "pushto".tr(),
      "15": "russian".tr(),
      "16": "spanish".tr(),
      "17": "turkish".tr(),
      "18": "urdu_hindi".tr(),
      "19": "other_language".tr(),
    },
  ),
  SearchFilter.education: FilterInfo(
    attr: UserAttribute.education,
    title: "education",
    icon: Icons.school,
    options: (ref) => {
      "1": "high_school".tr(),
      "2": "undergraduate".tr(),
      "3": "bachelors_degree".tr(),
      "4": "diploma".tr(),
      "5": "masters_degree".tr(),
      "6": "phd".tr(),
      "100": "other_education".tr(),
    },
  ),
  SearchFilter.race: FilterInfo(
    attr: UserAttribute.race,
    title: "race",
    icon: Icons.face_5,
    options: (ref) => {
      "1": "african",
      "2": "arabic",
      "3": "asian",
      "4": "latino",
      "5": "white_caucasian",
      "100": "other",
    },
  ),
  SearchFilter.religion: FilterInfo(
    attr: UserAttribute.religion,
    title: "religion",
    icon: Icons.mosque,
    options: (ref) => {
      "1": "muslim".tr(),
      "11": "christian".tr(),
      "21": "jew".tr(),
      "31": "hindu".tr(),
      "32": "buddhist".tr(),
      "100": "other".tr(),
    },
  ),
  SearchFilter.disability: FilterInfo(
    attr: UserAttribute.disability,
    title: "disability",
    icon: Icons.accessible,
    options: (ref) => {
      "1": "no".tr(),
      "2": "20%".tr(),
      "3": "40%".tr(),
      "4": "60%".tr(),
      "5": "80%".tr(),
    },
  ),
  SearchFilter.dress: FilterInfo(
    attr: UserAttribute.dress,
    title: "dress",
    icon: Icons.woman,
    options: (ref) => {
      "1": "no_restrictions".tr(),
      "2": "regular_with_head_scarf".tr(),
      "3": "wide_without_head_scarf".tr(),
      "4": "wide_with_head_scarf".tr(),
      "5": "khimar_and_gilbab".tr(),
      "6": "niqab_showing_eyes".tr(),
      "7": "niqab_covering_all_face".tr(),
    },
  ),
  SearchFilter.shape: FilterInfo(
    attr: UserAttribute.shape,
    title: "shape",
    icon: Icons.accessibility,
    options: (ref) => {
      "1": "athletic".tr(),
      "2": "good".tr(),
      "4": "average".tr(),
      "5": "not_good".tr(),
    },
  ),
  SearchFilter.face: FilterInfo(
    attr: UserAttribute.face,
    title: "face",
    icon: Icons.face_2,
    options: (ref) => {
      "1": "very_attractive".tr(),
      "2": "attractive".tr(),
      "4": "average_attraction".tr(),
      "5": "not_attractive".tr(),
    },
  ),
  SearchFilter.district: FilterInfo(
    attr: UserAttribute.district,
    title: "district",
    icon: Icons.apartment,
    options: (ref) => {
      "1": "rich_neighborhood".tr(),
      "2": "good_neighborhood".tr(),
      "4": "average_neighborhood".tr(),
      "5": "poor_neighborhood".tr(),
    },
  ),
  SearchFilter.polygamy: FilterInfo(
    attr: UserAttribute.polygamy,
    title: "polygamy",
    icon: Icons.groups_3,
    options: (ref) => {
      "1": "accepting_polygamy".tr(),
      "2": "accepting_polygamy_with_conditions".tr(),
      "4": "not_accepting_polygamy".tr(),
    },
  ),
};
