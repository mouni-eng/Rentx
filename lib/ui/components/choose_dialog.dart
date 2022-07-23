import 'package:flutter/material.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';

import 'custom_text.dart';

class ChooseDialogOption {
  late String key;
  late String value;

  ChooseDialogOption({required this.key, required this.value});
}

class ChooseDialog extends StatelessWidget {
  const ChooseDialog(
      {Key? key,
      required this.title,
      required this.onChanged,
      required this.options,
      required this.selectedKey})
      : super(key: key);

  final String title;
  final String selectedKey;
  final List<ChooseDialogOption> options;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentXContext) => Dialog(
        child: Container(
            width: double.infinity,
            height: height(options.length * 80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width(25),
                vertical: height(25),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    text: title,
                    fontSize: width(14),
                    color: rentXContext.theme.customTheme.primary,
                  ),
                  ...options.map((e) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: rentXContext.translate(e.value),
                                fontSize: width(14),
                                color: rentXContext
                                    .theme.customTheme.kSecondaryColor,
                              ),
                              SizedBox(
                                width: width(25),
                                height: height(25),
                                child: Checkbox(
                                  value: selectedKey == e.key,
                                  activeColor:
                                      rentXContext.theme.customTheme.primary,
                                  onChanged: (b) => onChanged?.call(e.key),
                                  shape: const CircleBorder(),
                                ),
                              ),
                            ],
                          ),
                          if (options.indexOf(e) < options.length - 1)
                            const Divider(
                              thickness: 0.8,
                            ),
                        ],
                      )),
                ],
              ),
            )),
      ),
    );
  }
}
