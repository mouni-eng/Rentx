import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_choose_image.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/rentx_imagepicker.dart';
import 'package:rentx/view_models/car_listing_cubit/cubit.dart';
import 'package:rentx/view_models/car_listing_cubit/states.dart';

class UploadPhotosWidget extends StatelessWidget {
  const UploadPhotosWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentX) => BlocConsumer<CarListingCubit, CarListingStates>(
        listener: (context, state) {},
        builder: (context, state) {
          CarListingCubit cubit = CarListingCubit.get(context);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  color: rentX.theme.customTheme.secondary,
                  fontSize: width(14),
                  text: rentX.translate("Add photos")),
              SizedBox(
                height: height(16),
              ),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: width(16),
                  mainAxisSpacing: height(16),
                  crossAxisCount: 3,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  bool hasImageSelected = cubit.images.length >= index + 1;
                  return RentXImagePicker(
                      showOnLongPress: hasImageSelected,
                      widgetBuilder: () => hasImageSelected
                          ? GestureDetector(
                              onTap: () {
                                cubit.updateImageFeatured(index);
                              },
                              child: _UploadedImageWidget(
                                  featured: cubit.featured == index,
                                  file: cubit.images[index]),
                            )
                          : const ChooseImageWidget(),
                      onFilePick: cubit.chooseImage);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _UploadedImageWidget extends StatelessWidget {
  final File file;
  final bool featured;

  const _UploadedImageWidget(
      {Key? key, required this.file, required this.featured})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentXContext) => Container(
        width: width(98),
        margin: EdgeInsets.symmetric(horizontal: width(3), vertical: height(3)),
        height: height(93),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image(
                width: double.infinity,
                height: double.infinity,
                image: FileImage(file),
                fit: BoxFit.fill,
              ),
            ),
            if (featured)
              Container(
                width: width(26),
                height: height(26),
                margin: EdgeInsets.symmetric(
                  horizontal: width(4),
                  vertical: height(4),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: rentXContext.theme.customTheme.onPrimary,
                ),
                child: Center(child: SvgPicture.asset("assets/img/heart.svg")),
              ),
          ],
        ),
      ),
    );
  }
}
