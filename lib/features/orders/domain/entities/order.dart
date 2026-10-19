import 'package:shopflow/features/orders/domain/entities/order_item.dart';

class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final DateTime createdAt;
  final String status;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.status,
  });
}
