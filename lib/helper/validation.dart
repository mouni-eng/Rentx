import 'package:rentx/extensions/string_extension.dart';
import 'package:rentx/infrastructure/localizations/translator.dart';

class Validators {
  static String? validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value)) {
      return 'Email address bad formated';
    } else {
      return null;
    }
  }

  static String? matchesPassword(String? match1, String? match2) {
    if (match1?.compareTo(match2 ?? '') != 0) {
      return 'passwordsDontMatch';
    }
    return null;
  }

  static String? minLength(int minLength, String? input) {
    return (input?.length ?? 0) < minLength
        ? Translator.translate('minLengthValidation').interpolate([minLength])
        : null;
  }

  static String? required(dynamic value) {
    if (value is String?) {
      return value != null && value.isNotEmpty ? null : 'required';
    }
    return value != null ? null : 'required';
  }

  static String? allOf(
      dynamic input, List<String? Function(String?)> validators) {
    for (Function(String?) validator in validators) {
      String? validation = validator.call(input);
      if (validation != null && validation.isNotEmpty) {
        return validation;
      }
    }
    return null;
  }
}
