import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopflow/features/cart/data/models/cart_item_model.dart';

class CartLocalDataSource {
  static const String _cartKey = 'cart_items';

  Future<List<CartItemModel>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_cartKey);

    if (cartJson == null) {
      return [];
    }

    final List<dynamic> decodedJson = jsonDecode(cartJson);

    return decodedJson
        .map(
          (item) =>
              CartItemModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  Future<void> saveCartItems(List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();

    final cartJson = jsonEncode(items.map((item) => item.toJson()).toList());

    await prefs.setString(_cartKey, cartJson);
  }
}
