import 'package:shared_preferences/shared_preferences.dart';

class WishlistLocalDataSource {
  static const String _wishlistKey = 'wishlist_product_ids';

  Future<List<int>> getWishlistIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_wishlistKey);

    if (ids == null) {
      return [];
    }

    return ids.map((id) => int.parse(id)).toList();
  }

  Future<void> saveWishlistIds(List<int> ids) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      _wishlistKey,
      ids.map((id) => id.toString()).toList(),
    );
  }
}
