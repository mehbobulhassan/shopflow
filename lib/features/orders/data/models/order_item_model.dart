import 'package:shopflow/features/orders/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    required super.unitPrice,
    required super.quantity,
    required super.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'image': image,
    };
  }

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      quantity: json['quantity'] as int,
      image: json['image'] as String,
    );
  }
}
