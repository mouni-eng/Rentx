import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rentx/models/car_mdels.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';

class TopBrandWidget extends StatelessWidget {
  const TopBrandWidget({
    Key? key,
    required this.topBrandsModel,
  }) : super(key: key);

  final TopBrandsResult topBrandsModel;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => Container(
          width: width(90),
          height: height(106),
          margin: EdgeInsets.symmetric(
            vertical: height(5),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    const Color(0xFF000000).withOpacity(0.05), //color of shadow
                //spread radius
                blurRadius: width(20), // blur radius
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                width: width(46),
                height: height(46), 
                imageUrl: topBrandsModel.fileUploadUrl ?? "",
              ),
              SizedBox(
                height: height(8),
              ),
              CustomText(
                color: rentxcontext.theme.customTheme.secondary,
                fontSize: width(14),
                text: rentxcontext.translate(topBrandsModel.make!),
              ),
            ],
          )),
    );
  }
}