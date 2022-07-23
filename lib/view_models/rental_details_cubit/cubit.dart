import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentx/models/rental_details_model.dart';
import 'package:rentx/services/rental_service.dart';
import 'package:rentx/ui/widgets/map/rentx_map_card.dart';
import 'package:rentx/view_models/rental_details_cubit/states.dart';
import 'package:url_launcher/url_launcher.dart';

class RentalDetailsCubit extends Cubit<RentalDetailsStates> {
  RentalDetailsCubit() : super(RentalDetailsStates());

  static RentalDetailsCubit get(context) => BlocProvider.of(context);

  final RentalService _rentalService = RentalService();
  int carousalIndex = 0;
  RentalDetailsResult? rentalDetailsResult;
  final RentXMapController mapController = RentXMapController();
  final CarouselController carouselController = CarouselController();

  changeIndex(int value) {
    carousalIndex = value;
    emit(OnChangeState());
  }

  getRentalDetails(String id) {
    emit(GetRentalDetailsLoadingState());
    _rentalService.getRentalDetails(id).then((value) {
      rentalDetailsResult = value.result;
      emit(GetRentalDetailsSuccessState());
    }).catchError((error) {
      emit(GetRentalDetailsErrorState());
    });
  }

  void launchMaps() {
    final String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${rentalDetailsResult!.company!.address!.latitude},${rentalDetailsResult!.company!.address!.longitude}';
    launch(googleUrl).then((value) => emit(OnChangeState()));
  }
}
