import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/best_deals.dart';
import 'package:rentx/ui/components/custom_filtering.dart';
import 'package:rentx/ui/components/custom_form_field.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/components/featured_dealers.dart';
import 'package:rentx/ui/components/header_widget.dart';
import 'package:rentx/ui/components/most_recent.dart';
import 'package:rentx/ui/components/topbrand_widget.dart';
import 'package:rentx/ui/screens/search_screen.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';
import 'package:rentx/view_models/home_cubit/states.dart';
import 'package:rentx/view_models/search_cubit/cubit.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          HomeCubit cubit = HomeCubit.get(context);
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width(16),
              vertical: height(16),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    color: rentxcontext.theme.customTheme.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    text: rentxcontext.translate("Choose a Car"),
                  ),
                  SizedBox(
                    height: height(16),
                  ),
                  CustomFormField(
                    context: context,
                    prefix: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width(16),
                        vertical: height(16),
                      ),
                      child: SvgPicture.asset(
                        "assets/img/search.svg",
                      ),
                    ),
                    hintText: rentxcontext.translate("Search here..."),
                  ),
                  SizedBox(
                    height: height(8),
                  ),
                  const CustomFilterWidget(),
                  SizedBox(
                    height: height(34),
                  ),
                  HeaderWidget(
                    title: rentxcontext.translate("Top Brands"),
                  ),
                  SizedBox(
                    height: height(18),
                  ),
                  ConditionalBuilder(
                    condition: state is! GetBestDealsLoadingState,
                    builder: (context) => SizedBox(
                      height: height(120),
                      child: ListView.separated(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => TopBrandWidget(
                                topBrandsModel: cubit.topBrandsList[index],
                              ),
                          separatorBuilder: (context, index) => SizedBox(
                                width: width(16),
                              ),
                          itemCount: cubit.topBrandsList.length),
                    ),
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  SizedBox(
                    height: height(34),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: width(5)),
                    child: HeaderWidget(
                      title: rentxcontext.translate("Most Recent"),
                      onTap: () {
                        SearchCubit.get(context)
                            .setRentals(cubit.mostRecentRentals);
                        rentxcontext.route((p0) => const SearchRentalScreen());
                      },
                    ),
                  ),
                  SizedBox(
                    height: height(16),
                  ),
                  ConditionalBuilder(
                    condition: state is! GetBestDealsLoadingState,
                    builder: (context) => CarouselSlider(
                      items: List.generate(
                        cubit.mostRecentRentals.length,
                        (index) => MostRecentWidget(
                          mostRecentModel: cubit.mostRecentRentals[index],
                        ),
                      ),
                      options: CarouselOptions(
                        height: height(196),
                        initialPage: 0,
                        onPageChanged: (index, reason) {},
                        viewportFraction: 1,
                        enableInfiniteScroll: true,
                        disableCenter: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 6),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  SizedBox(
                    height: height(34),
                  ),
                  HeaderWidget(
                    title: rentxcontext.translate("Featured Dealers"),
                  ),
                  SizedBox(
                    height: height(16),
                  ),
                  ConditionalBuilder(
                    condition: state is! GetBestDealsLoadingState,
                    builder: (context) => SizedBox(
                      height: height(210),
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) =>
                              FeaturedDealersWidget(
                                model: cubit.featuredDealersList[index],
                              ),
                          separatorBuilder: (context, index) => SizedBox(
                                width: width(16),
                              ),
                          itemCount: cubit.featuredDealersList.length),
                    ),
                    fallback: (context) => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  SizedBox(
                    height: height(34),
                  ),
                  HeaderWidget(
                    title: rentxcontext.translate("Best Deals"),
                    onTap: () {
                      SearchCubit.get(context)
                          .setRentals(cubit.bestDealsRentals);
                      rentxcontext.route((p0) => const SearchRentalScreen());
                    },
                  ),
                  SizedBox(
                    height: height(16),
                  ),
                  ConditionalBuilder(
                      condition: state is! GetBestDealsLoadingState,
                      builder: (context) => ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => BestDealsWidget(
                              model: cubit.firstBestDeals[index],
                            ),
                            separatorBuilder: (context, index) => SizedBox(
                              height: height(16),
                            ),
                            itemCount: cubit.firstBestDeals.length,
                          ),
                      fallback: (context) => const Center(
                            child: CircularProgressIndicator.adaptive(),
                          )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
