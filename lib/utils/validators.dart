import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';

String? emailValidator(String? value) {
  return EmailValidator.validate(value ?? '') ? null : "invalid_email".tr();
}

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'password_required'.tr();
  }
  if (value.length < 6) {
    return 'password_length_error'.tr();
  }
  return null;
}
