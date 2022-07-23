import 'package:flutter/material.dart';

class UIUtils {
  static List<Widget> widgetListFlatMapper<T>(List<T> inputList,
      List<Widget> Function(T) mapper, List<Widget> Function()? divider) {
    List<Widget> widgets = [];
    for (var element in inputList) {
      bool isLast = inputList.indexOf(element) == inputList.length - 1;
      widgets.addAll(mapper.call(element));
      if (!isLast && divider != null) {
        widgets.addAll(divider.call());
      }
    }
    return widgets;
  }
}
