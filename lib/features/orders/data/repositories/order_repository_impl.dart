import 'package:shopflow/features/orders/data/datasource/order_local_data_source.dart';
import 'package:shopflow/features/orders/data/models/order_item_model.dart';
import 'package:shopflow/features/orders/data/models/order_model.dart';
import 'package:shopflow/features/orders/domain/entities/order.dart';
import 'package:shopflow/features/orders/domain/entities/order_item.dart';
import 'package:shopflow/features/orders/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource dataSource;

  OrderRepositoryImpl(this.dataSource);

  @override
  Future<void> saveOrder(Order order) async {
    final orderModel = OrderModel(
      id: order.id,
      items: order.items
          .map(
            (item) => OrderItemModel(
              productId: item.productId,
              productName: item.productName,
              unitPrice: item.unitPrice,
              quantity: item.quantity,
              image: item.image,
            ),
          )
          .toList(),
      totalAmount: order.totalAmount,
      createdAt: order.createdAt,
      status: order.status,
    );

    await dataSource.saveOrder(orderModel);
  }

  @override
  Future<List<Order>> getOrders() async {
    final orderModels = await dataSource.getOrders();

    return orderModels
        .map(
          (model) => Order(
            id: model.id,
            items: model.items
                .map(
                  (item) => OrderItem(
                    productId: item.productId,
                    productName: item.productName,
                    unitPrice: item.unitPrice,
                    quantity: item.quantity,
                    image: item.image,
                  ),
                )
                .toList(),
            totalAmount: model.totalAmount,
            createdAt: model.createdAt,
            status: model.status,
          ),
        )
        .toList();
  }

  @override
  Future<Order?> getOrderById(String id) async {
    final orderModel = await dataSource.getOrderById(id);

    if (orderModel == null) {
      return null;
    }

    return Order(
      id: orderModel.id,
      items: orderModel.items
          .map(
            (item) => OrderItem(
              productId: item.productId,
              productName: item.productName,
              unitPrice: item.unitPrice,
              quantity: item.quantity,
              image: item.image,
            ),
          )
          .toList(),
      totalAmount: orderModel.totalAmount,
      createdAt: orderModel.createdAt,
      status: orderModel.status,
    );
  }
}
