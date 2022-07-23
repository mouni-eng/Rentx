import 'package:rentx/infrastructure/local_storage.dart';
import 'package:rentx/models/car.dart';

class WishlistService {
  final LocalStorage _localStorage = LocalStorage();

  Future<void> add(final CarListing carListing) async {
    await _localStorage.addToJsonArray(
        LocalStorageKeys.wishlist, carListing.toJson());
  }

  Future<void> remove(final CarListing carListing) async {
    await _localStorage.removeFromJsonArray(
        LocalStorageKeys.wishlist, (json) => json['id'] == carListing.id);
  }

  Future<List<CarListing>> getWishlist() async {
    return (await _localStorage.getAsJsonArray(LocalStorageKeys.wishlist))
            ?.map((e) => CarListing.fromJson(e))
            .toList() ??
        [];
  }

  Future<bool> isPartOfWishlist(CarListing listing) async {
    final wishlist = await getWishlist();
    return wishlist.isNotEmpty &&
        wishlist.where((element) => element.id == listing.id).isNotEmpty;
  }
}
