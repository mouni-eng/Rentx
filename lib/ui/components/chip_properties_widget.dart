import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/screens/home/filtring_screen.dart';

import 'custom_text.dart';

class StringChipModel extends ChipModel<String> {
  final String value;

  StringChipModel(this.value);

  @override
  bool equals(ChipModel chipModel) {
    final StringChipModel str = chipModel as StringChipModel;
    return str.value == value;
  }

  @override
  String label() {
    return value;
  }

  @override
  String get() {
    return value;
  }
}

abstract class ChipModel<T> {
  bool equals(ChipModel chipModel);

  String label();

  T get();
}

class ChipPropertiesWidget extends StatelessWidget {
  const ChipPropertiesWidget(
      {Key? key,
      required this.values,
      required this.label,
      required this.onSelect,
      required this.selectedValue})
      : super(key: key);

  final String label;
  final List<ChipModel> values;
  final Function(ChipModel) onSelect;
  final ChipModel selectedValue;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentxcontext) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  color: rentxcontext.theme.customTheme.headdline,
                  fontSize: width(14),
                  fontWeight: FontWeight.w500,
                  text: rentxcontext.translate(label),
                ),
                SizedBox(
                  height: height(10),
                ),
                SizedBox(
                  height: height(60),
                  child: ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final ChipModel value = values[index];
                        return value.equals(selectedValue)
                            ? ChoosenFilterItem(title: value.label())
                            : GestureDetector(
                                onTap: () {
                                  onSelect.call(value);
                                },
                                child: FilterItem(
                                  title: value.label(),
                                ),
                              );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            width: width(16),
                          ),
                      itemCount: values.length),
                ),
              ],
            ));
  }
}
