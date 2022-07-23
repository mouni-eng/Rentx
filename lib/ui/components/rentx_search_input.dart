import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rentx/constants.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_form_field.dart';
import 'package:rentx/ui/components/custom_overlay_dropDown.dart';
import 'package:rentx/ui/components/custom_text.dart';

class MapSearchBar<T> extends StatefulWidget {
  final Widget? leadingIcon;
  final Widget? suffixIcon;
  final String? placeholder;
  final Future<List<T>> Function(String)? onChange;
  final Widget Function(T) itemBuilder;
  final Function(T)? onItemClick;
  final String Function(T)? valueProvider;
  final bool isVissible;
  final void Function() onDismiss;
  final void Function() onTap;

  const MapSearchBar({
    Key? key,
    this.placeholder,
    this.onChange,
    this.leadingIcon,
    required this.itemBuilder,
    this.onItemClick,
    this.valueProvider,
    this.suffixIcon,
    required this.isVissible,
    required this.onTap,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<MapSearchBar<T>> createState() => _MapSearchBarState<T>();
}

class _MapSearchBarState<T> extends State<MapSearchBar<T>> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  List<T> _items = [];
  bool _listenChange = true;
  bool? _isEmpty;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentXContext) => CustomOverLayWidget(
        widgetBuilder: Container(
          height: height(46),
          decoration: BoxDecoration(boxShadow: [
            boxShadow,
          ]),
          child: CustomFormField(
            controller: _searchController,
            isMapSearch: true,
            onChange: (value) {
              _onSearchChanged();
            },
            hintText: "Search here...",
            context: context,
            suffix: GestureDetector(
                onTap: () {
                  widget.onDismiss();
                  _items = [];
                  _listenChange = false;
                  _searchController.clear();
                },
                child: widget.suffixIcon),
            prefix: widget.leadingIcon,
          ),
        ),
        overlayBuilder: _items.isEmpty
            ? Container(
                height: height(100),
                padding: EdgeInsets.symmetric(
                  horizontal: width(10),
                  vertical: height(16),
                ),
                decoration: BoxDecoration(
                    color: rentXContext.theme.customTheme.onPrimary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      boxShadow,
                    ]),
                child: Center(
                  child: CustomText(
                    fontSize: width(16),
                    text: "No Search Results...",
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width(10),
                  vertical: height(16),
                ),
                decoration: BoxDecoration(
                  color: rentXContext.theme.customTheme.onPrimary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ..._items
                          .map((e) => Column(
                                children: [
                                  InkWell(
                                    onTap: () => _onItemTap(e),
                                    child: widget.itemBuilder.call(e),
                                  ),
                                  const Divider(
                                    thickness: 1.3,
                                  ),
                                ],
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ),
        visible: widget.isVissible,
        onDismiss: widget.onDismiss,
      ),
    );
  }

  _onSearchChanged() async {
    widget.onTap();
    final String query = _searchController.text;
    if (query.isEmpty) {
      _isEmpty = null;
    }
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (_listenChange) {
        final res = await widget.onChange?.call(query);
        setState(() {
          if (query.isNotEmpty) {
            _isEmpty = res != null && res.isEmpty;
          }
          _items = res ?? [];
        });
      }
      _listenChange = true;
    });
  }

  void _onItemTap(T item) {
    widget.onDismiss();
    widget.onItemClick?.call(item);
    setState(() {
      FocusScope.of(context).unfocus();
      _items = [];
      _listenChange = false;
      if (widget.valueProvider != null) {
        _searchController.text = widget.valueProvider!.call(item);
      }
      _isEmpty = null;
    });
  }
}
