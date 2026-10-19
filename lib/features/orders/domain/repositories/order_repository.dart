import 'package:shopflow/features/orders/domain/entities/order.dart';

abstract class OrderRepository {
  Future<void> saveOrder(Order order);

  Future<List<Order>> getOrders();

  Future<Order?> getOrderById(String id);
}
