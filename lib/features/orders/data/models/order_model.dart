import 'package:shopflow/features/orders/data/models/order_item_model.dart';
import 'package:shopflow/features/orders/domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.items,
    required super.totalAmount,
    required super.createdAt,
    required super.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items
          .map(
            (item) => OrderItemModel(
              productId: item.productId,
              productName: item.productName,
              unitPrice: item.unitPrice,
              quantity: item.quantity,
              image: item.image,
            ).toJson(),
          )
          .toList(),
      'totalAmount': totalAmount,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>)
          .map(
            (item) =>
                OrderItemModel.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
    );
  }
}
