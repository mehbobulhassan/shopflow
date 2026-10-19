import 'package:shopflow/features/cart/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({required super.productId, required super.quantity});

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: json['productId'] as int,
      quantity: json['quantity'] as int,
    );
  }
}
