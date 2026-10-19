import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopflow/features/orders/data/models/order_model.dart';

class OrderLocalDataSource {
  static const String _ordersKey = 'shopflow_orders';

  Future<void> saveOrder(OrderModel order) async {
    final prefs = await SharedPreferences.getInstance();

    // Load previously saved orders.
    final orders = await getOrders();

    // Add the new order without removing existing orders.
    orders.add(order);

    // Convert orders to JSON and save them as a string.
    final ordersJson = jsonEncode(
      orders.map((order) => order.toJson()).toList(),
    );

    await prefs.setString(_ordersKey, ordersJson);
  }

  Future<List<OrderModel>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString(_ordersKey);

    if (ordersJson == null) {
      return [];
    }

    final List<dynamic> decodedJson = jsonDecode(ordersJson);

    return decodedJson
        .map(
          (order) =>
              OrderModel.fromJson(Map<String, dynamic>.from(order as Map)),
        )
        .toList();
  }

  Future<OrderModel?> getOrderById(String id) async {
    final orders = await getOrders();

    for (final order in orders) {
      if (order.id == id) {
        return order;
      }
    }

    return null;
  }
}
