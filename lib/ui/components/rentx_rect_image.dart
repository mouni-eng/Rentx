import 'package:flutter/material.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/rentx_cached_image.dart';

class RentXRectImage extends StatelessWidget {
  final String? imageSrc;
  final String avatarLetters;

  const RentXRectImage(
      {Key? key, required this.imageSrc, required this.avatarLetters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (context) {
        return Container(
          height: width(64),
          width: width(64),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.black.withOpacity(0.9)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageSrc != null && imageSrc!.isNotEmpty
                ? RentXCachedImage(
                    url: imageSrc!,
                    boxFit: BoxFit.cover,
                    boxShape: BoxShape.rectangle,
                  )
                : Container(
                    color: context.theme.customTheme.primary,
                    height: width(64),
                    width: width(64),
                    child: CircleAvatar(
                      child: CustomText(
                          text: avatarLetters,
                          fontSize: width(20),
                          fontWeight: FontWeight.bold,
                          color: context.theme.theme.colorScheme.onPrimary),
                      backgroundColor: context.theme.customTheme.primary,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
