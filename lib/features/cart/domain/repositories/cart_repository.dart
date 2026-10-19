import 'package:shopflow/features/cart/domain/entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> saveCartItems(List<CartItem> items);
}
