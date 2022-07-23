import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rentx/services/alert_service.dart';
import 'package:rentx/size_config.dart';
import 'package:rentx/ui/base_widget.dart';
import 'package:rentx/ui/components/custom_button.dart';
import 'package:rentx/ui/components/custom_form_field.dart';
import 'package:rentx/ui/components/custom_text.dart';
import 'package:rentx/ui/widgets/map/rentx_location_searchbar.dart';
import 'package:rentx/ui/widgets/map/rentx_map_card.dart';
import 'package:rentx/view_models/company_auth_cubit/cubit.dart';
import 'package:rentx/view_models/company_auth_cubit/states.dart';

class AddressSelection extends StatefulWidget {
  const AddressSelection({Key? key}) : super(key: key);

  @override
  State<AddressSelection> createState() => _AddressSelectionState();
}

class _AddressSelectionState extends State<AddressSelection> {
  @override
  void initState() {
    // TODO: implement initState
    CompanyAuthCubit.get(context).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) =>
          BlocConsumer<CompanyAuthCubit, CompanyAuthStates>(
              builder: (context, state) {
        CompanyAuthCubit cubit = CompanyAuthCubit.get(context);
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  RentXMapCard(
                    onPositionTap: (pos) => cubit.setPosition(pos),
                    width: double.infinity,
                    height: height(503),
                    location: cubit.location,
                    controller: cubit.mapController,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: width(16),
                      vertical: height(16),
                    ),
                    child: RentXLocationSearchbar(
                        isVisible: cubit.isVisible,
                        onTap: cubit.searchOnTap,
                        onDismiss: cubit.searchOnChange,
                        locationProvider: (address) =>
                            cubit.searchLocation(address),
                        onLocationPick: (location) {
                          cubit.updateLocation(location);
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: height(24),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width(24),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          cubit.getCurrentLocation();
                        },
                        child: const GetCurrentLocation()),
                    SizedBox(
                      height: height(24),
                    ),
                    Container(
                      width: double.infinity,
                      height: height(150),
                      padding: EdgeInsets.symmetric(
                        horizontal: width(16),
                        vertical: height(16),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: rentxcontext.theme.customTheme.onPrimary,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000)
                                .withOpacity(0.06), //color of shadow
                            //spread radius
                            blurRadius: width(30), // blur radius
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            color: rentxcontext.theme.customTheme.headdline,
                            fontSize: width(14),
                            text: "Additional Details",
                          ),
                          const Divider(
                            thickness: 0.8,
                          ),
                          SizedBox(
                            height: height(16),
                          ),
                          CustomFormField(
                            context: context,
                            hintText: 'searchAddress',
                            onChange: (value) {
                              cubit.onChangeCompanyNotes(value);
                            },
                            validate: (value) {
                              if (value!.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height(16),
                    ),
                    CustomButton(
                      showLoader: state is CompanyRegisterLoadingState,
                      text: rentxcontext.translate("Submit"),
                      radius: 6,
                      fontSize: width(16),
                      btnWidth: double.infinity,
                      function: () {
                        cubit.saveCompany();
                      },
                      isUpperCase: false,
                    ),
                    SizedBox(
                      height: height(20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }, listener: (context, state) {
        if (state is CompanyRegisterErrorState) {
          AlertService.showSnackbarAlert(
            state.error ?? '',
            rentxcontext,
            SnackbarType.error,
          );
        }
      }),
    );
  }
}

class GetCurrentLocation extends StatelessWidget {
  const GetCurrentLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
      builder: (rentxcontext) => Container(
        width: double.infinity,
        height: height(74),
        padding: EdgeInsets.symmetric(
          horizontal: width(16),
          vertical: height(16),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: rentxcontext.theme.customTheme.onPrimary,
          boxShadow: [
            BoxShadow(
              color:
                  const Color(0xFF000000).withOpacity(0.06), //color of shadow
              //spread radius
              blurRadius: width(30), // blur radius
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            SvgPicture.asset("assets/img/gps.svg"),
            SizedBox(
              width: width(8),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  color: rentxcontext.theme.customTheme.primary,
                  fontSize: width(16),
                  text: "Current Location",
                ),
                CustomText(
                  color: rentxcontext.theme.customTheme.headline3,
                  fontSize: width(12),
                  height: 0.8,
                  text: "Using GPS",
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            const Spacer(),
            SvgPicture.asset("assets/img/arrow-left.svg"),
          ],
        ),
      ),
    );
  }
}
