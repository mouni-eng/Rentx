extension StringExtension on String {
  String capitalize() {
    if (isNotEmpty) {
      return "${this[0].toUpperCase()}${substring(1)}";
    }
    return "";
  }

  String interpolate(List<dynamic> params) {
    return _interpolate(this, params);
  }
}

String _interpolate(String string, List<dynamic> params) {
  String result = string;
  for (int i = 0; i < params.length; i++) {
    result = result.replaceAll('{$i}', params[i]);
  }

  return result;
}
