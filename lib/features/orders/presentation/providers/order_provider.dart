import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopflow/features/orders/data/datasource/order_local_data_source.dart';
import 'package:shopflow/features/orders/data/repositories/order_repository_impl.dart';
import 'package:shopflow/features/orders/domain/entities/order.dart';
import 'package:shopflow/features/orders/domain/repositories/order_repository.dart';

final orderLocalDataSourceProvider = Provider<OrderLocalDataSource>((ref) {
  return OrderLocalDataSource();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dataSource = ref.watch(orderLocalDataSourceProvider);
  return OrderRepositoryImpl(dataSource);
});

final ordersProvider = AsyncNotifierProvider<OrdersNotifier, List<Order>>(
  OrdersNotifier.new,
);

class OrdersNotifier extends AsyncNotifier<List<Order>> {
  @override
  Future<List<Order>> build() async {
    final repository = ref.watch(orderRepositoryProvider);
    return repository.getOrders();
  }

  Future<void> placeOrder(Order order) async {
    final repository = ref.read(orderRepositoryProvider);

    // Save first. If this throws, state won't report success.
    await repository.saveOrder(order);

    // Update Riverpod state only after saving succeeds.
    final currentOrders = state.requireValue;

    state = AsyncData([...currentOrders, order]);
  }
}
