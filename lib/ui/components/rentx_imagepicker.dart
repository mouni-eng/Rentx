import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';

import 'custom_text.dart';

class RentXImagePicker extends StatelessWidget {
  const RentXImagePicker(
      {Key? key,
      required this.widgetBuilder,
      required this.onFilePick,
      this.showOnLongPress = false})
      : super(key: key);

  final Widget Function() widgetBuilder;
  final Function(File) onFilePick;
  final bool? showOnLongPress;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (context) => GestureDetector(
        onLongPress: () => showOnLongPress! ? _showBottomSheet(context) : null,
        onTap: () => showOnLongPress! ? null : _showBottomSheet(context),
        child: widgetBuilder.call(),
      ),
    );
  }

  void _showBottomSheet(RentXContext context) {
    showModalBottomSheet(
        context: context.context,
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
                color: context.theme.theme.backgroundColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _getFromCamera(context),
                            icon: const Icon(Icons.camera),
                            tooltip: 'Test',
                            color: context.theme.customTheme.primary,
                          ),
                          CustomText(
                            text: context.translate('gallery'),
                            fontSize: width(12),
                          )
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () => _getFromGallery(context),
                              icon: const Icon(Icons.image_sharp),
                              color: context.theme.customTheme.primary),
                          CustomText(
                            text: context.translate('gallery'),
                            fontSize: width(12),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  _getFromGallery(RentXContext context) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      onFilePick.call(File(pickedFile.path));
      context.pop();
    }
  }

  /// Get from Camera
  _getFromCamera(RentXContext context) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      onFilePick.call(File(pickedFile.path));
      context.pop();
    }
  }
}
