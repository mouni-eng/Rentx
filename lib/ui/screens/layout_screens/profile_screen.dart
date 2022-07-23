import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/infrastructure/localizations/language.dart';
import 'package:rentx/models/currency.dart';
import 'package:rentx/models/user.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/screens/auth_screens/user_registration_screens/personal_data_screen.dart';
import 'package:rentx/ui/screens/layout_screens/layout_screen.dart';
import 'package:rentx/view_models/home_cubit/cubit.dart';
import 'package:rentx/view_models/manager_cubit/cubit.dart';
import 'package:rentx/view_models/profile_cubit/cubit.dart';
import 'package:rentx/view_models/profile_cubit/states.dart';

import '../../components/choose_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => BlocConsumer<ProfileCubit, ProfileStates>(
        listener: (context, state) {
          if (state is LoggedOutState) {
            if (state.loggedUserRole == UserRole.manager) {
              HomeCubit.get(context).getHomeData();
            }
            HomeCubit.get(context).chooseBottomNavIndex(0);
            rentxcontext.route((p0) => const LayoutScreen());
          }
        },
        builder: (context, state) {
          ProfileCubit cubit = ProfileCubit.get(context);
          return SafeArea(
              child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width(16),
                vertical: height(16),
              ),
              child: ConditionalBuilder(
                condition: state is! GetUserDetailsLoadingState &&
                    state is! GetUserDetailsErrorState &&
                    state is! LoggedOutState,
                builder: (context) => SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          BackButtonWidget(
                            rentxcontext: rentxcontext,
                            onTap: () {
                              if (cubit.userDetails!.role == UserRole.client) {
                                HomeCubit.get(context).chooseBottomNavIndex(0);
                              } else {
                                ManagerCubit.get(context).changeBottomNav(0);
                              }
                            },
                          ),
                          SizedBox(
                            width: width(16),
                          ),
                          CustomText(
                            color: rentxcontext.theme.customTheme.headdline,
                            fontSize: width(22),
                            text: "profile",
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height(32),
                      ),
                      Center(
                        child: Column(
                          children: [
                            ProfilePictureWidget(
                                    profileImageUrl: cubit.userDetails!.profilePictureUrl,
                              profileImage: cubit.profileImage,
                              onPickImage: cubit.chooseProfileImage,
                            ),
                            SizedBox(
                              height: height(16),
                            ),
                            CustomText(
                              color: rentxcontext.theme.customTheme.headdline,
                              fontSize: width(18),
                              text: cubit.userDetails!.getFullName(),
                              fontWeight: FontWeight.w600,
                            ),
                            CustomText(
                              color: rentxcontext.theme.customTheme.headline2,
                              fontSize: width(14),
                              text: cubit.userDetails!.email!,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height(24),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      SizedBox(
                        height: height(24),
                      ),
                      Row(
                        children: [
                          const CustomProfileCard(
                            img: "assets/img/local-two.svg",
                            title: "address",
                          ),
                          SizedBox(
                            width: width(16),
                          ),
                          const CustomProfileCard(
                            img: "assets/img/bank-transfer.svg",
                            title: "payment",
                          ),
                          SizedBox(
                            width: width(16),
                          ),
                          const CustomProfileCard(
                            img: "assets/img/book.svg",
                            title: "history",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height(44),
                      ),
                      CustomProfileListTile(
                        title: "wishlist",
                        img: "assets/img/like.svg",
                        onPressed: () {},
                      ),
                      CustomProfileListTile(
                        title: "notifications",
                        img: "assets/img/remind.svg",
                        onPressed: () {},
                      ),
                      CustomProfileListTile(
                        title: "darkMode",
                        isDark: true,
                        img: "assets/img/moon.svg",
                        onPressed: () => {},
                      ),
                      CustomProfileListTile(
                        title: "language",
                        img: "assets/img/translate 1.svg",
                        isCustom: true,
                        subTitle: Language.currentLanguage.languageName,
                        onPressed: () {
                          showDialog(
                              barrierColor: Colors.black.withOpacity(0.8),
                              context: context,
                              builder: (context) => ChooseDialog(
                                    title: "chooseLanguage",
                                    onChanged: (value) {
                                      cubit.switchLanguage(value);
                                      Navigator.of(context).pop();
                                    },
                                    options: Language.languages
                                        .map((e) => ChooseDialogOption(
                                            key: e.locale.languageCode,
                                            value: e.languageName))
                                        .toList(),
                                    selectedKey: Language
                                        .currentLanguage.locale.languageCode,
                                  ));
                        },
                      ),
                      CustomProfileListTile(
                        title: "currency",
                        subTitle:
                            cubit.activeCurrency?.name.toUpperCase() ?? '',
                        isCustom: true,
                        img: "assets/img/currency.svg",
                        onPressed: () {
                          showDialog(
                              barrierColor: Colors.black.withOpacity(0.8),
                              context: context,
                              builder: (context) => ChooseDialog(
                                    title: "chooseCurrency",
                                    selectedKey:
                                        cubit.activeCurrency?.name ?? '',
                                    onChanged: (value) {
                                      cubit.switchCurrency(value);
                                      Navigator.of(context).pop();
                                    },
                                    options: Currency.values
                                        .map((e) => ChooseDialogOption(
                                            key: e.name,
                                            value: e.name.toUpperCase()))
                                        .toList(),
                                  ));
                        },
                      ),
                      CustomProfileListTile(
                        title: "helpAndSupport",
                        img: "assets/img/help.svg",
                        onPressed: () {},
                      ),
                      CustomProfileListTile(
                        title: "logOut",
                        img: "assets/img/logout.svg",
                        onPressed: () {
                          cubit.logout();
                        },
                      ),
                    ],
                  ),
                ),
                fallback: (BuildContext context) => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}

class CustomProfileListTile extends StatelessWidget {
  const CustomProfileListTile({
    Key? key,
    this.onPressed,
    required this.title,
    required this.img,
    this.isCustom = false,
    this.isDark = false,
    this.subTitle = "",
  }) : super(key: key);

  final Function()? onPressed;
  final String title, img, subTitle;
  final bool isCustom, isDark;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => ListTile(
        onTap: onPressed,
        leading: Container(
          width: width(46),
          height: height(46),
          padding: EdgeInsets.symmetric(
            horizontal: width(10),
            vertical: height(10),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: rentxcontext.theme.customTheme.profileFill,
          ),
          child: SvgPicture.asset(img),
        ),
        title: CustomText(
          color: rentxcontext.theme.customTheme.headdline,
          fontSize: width(16),
          text: title,
        ),
        trailing: isCustom
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                      color: rentxcontext.theme.customTheme.headdline,
                      fontSize: width(14),
                      text: subTitle),
                  const Icon(Icons.arrow_forward_ios_rounded),
                ],
              )
            : isDark
                ? Switch.adaptive(
                    value: ProfileCubit.get(context).isDark,
                    onChanged: (value) {
                      ProfileCubit.get(context).switchTheme(context);
                    })
                : const Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}

class CustomProfileCard extends StatelessWidget {
  const CustomProfileCard({
    Key? key,
    required this.title,
    required this.img,
  }) : super(key: key);

  final String title, img;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => Container(
        width: width(98),
        height: height(96),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: rentxcontext.theme.customTheme.headline4,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(img),
            SizedBox(
              height: height(10),
            ),
            CustomText(
              color: rentxcontext.theme.customTheme.headdline,
              fontSize: width(16),
              text: title,
            ),
          ],
        ),
      ),
    );
  }
}

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({
    Key? key,
    required this.rentxcontext,
    this.onTap,
  }) : super(key: key);

  final RentXContext rentxcontext;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width(46),
        height: height(46),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: rentxcontext.theme.customTheme.inputFieldBorder,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
        ),
      ),
    );
  }
}
