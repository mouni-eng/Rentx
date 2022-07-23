import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';

import 'custom_text.dart';

class KeyValue<T> {
  final T key;
  final String value;

  KeyValue({required this.key, required this.value});
}

class CustomDropdownSearch<T> extends StatelessWidget {
  const CustomDropdownSearch(
      {Key? key,
      required this.entries,
      this.selectedValue,
      required this.onChange,
      required this.label,
      this.validator,
      this.enabled,
      this.showSearchBox = true,
      this.compareFn})
      : super(key: key);

  final String label;
  final List<KeyValue<T>> entries;
  final KeyValue<T>? selectedValue;
  final Function(KeyValue<T>) onChange;
  final String? Function(KeyValue<T>?)? validator;
  final bool? enabled;
  final bool? showSearchBox;
  final bool? Function(KeyValue<T>, KeyValue<T>)? compareFn;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (rentXContext) => DropdownSearch<KeyValue<T>>(
              enabled: enabled == null || enabled!,
              autoValidateMode: AutovalidateMode.always,
              items: entries,
              validator: validator,
              onChanged: (val) => onChange.call(val!),
              dropdownButtonProps: DropdownButtonProps(
                icon: SvgPicture.asset("assets/img/dropdown.svg"),
              ),
              dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: width(16),
                ),
                filled: true,
                fillColor: rentXContext.theme.customTheme.inputFieldFill,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFE3E3E8))),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              )),
              selectedItem: selectedValue,
              compareFn: (k1, k2) => compareFn?.call(k1, k2) ?? k1 == k2,
              filterFn: (kv, str) => rentXContext
                  .translate(kv.value)
                  .toLowerCase()
                  .contains(str.toLowerCase()),
              popupProps: PopupProps.menu(
                  scrollbarProps: ScrollbarProps(
                      radius: const Radius.circular(2),
                      thumbColor: rentXContext.theme.customTheme.primary,
                      thickness: width(4),
                      interactive: true,
                      thumbVisibility: true,
                      trackRadius: const Radius.circular(2),
                      minThumbLength: height(32),
                      minOverscrollLength: height(15),
                      trackBorderColor:
                          rentXContext.theme.customTheme.inputFieldFill,
                      trackColor: rentXContext.theme.customTheme.inputFieldFill,
                      trackVisibility: true),
                  showSelectedItems: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: rentXContext.translate('searchHere'),
                      fillColor: rentXContext.theme.customTheme.inputFieldFill,
                      filled: true,
                      counterText: "",
                      focusColor: Colors.transparent,
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(16),
                          vertical: height(16),
                        ),
                        child: SvgPicture.asset(
                          "assets/img/search.svg",
                          color: rentXContext
                              .theme.customTheme.kSecondaryColorBold,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: width(15), vertical: height(14)),
                      hintStyle: TextStyle(
                        fontSize: width(14),
                        color: rentXContext.theme.customTheme.kSecondaryColor,
                      ),
                      labelStyle: Theme.of(context).textTheme.subtitle2,
                      alignLabelWithHint: false,
                      floatingLabelStyle:
                          Theme.of(context).textTheme.subtitle2!.copyWith(
                                color: rentXContext.theme.theme.primaryColor,
                              ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                rentXContext.theme.customTheme.inputFieldBorder,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color:
                                rentXContext.theme.customTheme.inputFieldBorder,
                          )),
                    ),
                  ),
                  itemBuilder: (context, kv, selected) {
                    return ListTile(
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                      leading: SizedBox(
                        width: width(16),
                        height: height(16),
                        child: Checkbox(
                          onChanged: (value) {},
                          activeColor: rentXContext.theme.customTheme.primary,
                          value: selected,
                        ),
                      ),
                      title: CustomText(
                          color: const Color(0xFF5A5F65),
                          fontSize: width(14),
                          text: rentXContext.translate(kv.value)),
                    );
                  },
                  showSearchBox: showSearchBox ?? true,
                  fit: FlexFit.loose,
                  listViewProps: const ListViewProps(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                  ),
                  containerBuilder: (context, popupWidget) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(16),
                          vertical: height(16),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFE3E3E8),
                          ),
                          color: Colors.white,
                        ),
                        child: popupWidget,
                      )),
              dropdownBuilder: (context, kv) => CustomText(
                  color: rentXContext.theme.customTheme.kSecondaryColor,
                  fontSize: width(14),
                  text: rentXContext.translate(kv?.value ?? label)),
            ));
  }
}
