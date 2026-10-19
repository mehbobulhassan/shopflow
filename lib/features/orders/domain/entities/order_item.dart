class OrderItem {
  final int productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final String image;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.image,
  });
}
