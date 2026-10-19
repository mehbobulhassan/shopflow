import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopflow/features/cart/presentation/screens/cart_screen.dart';
import 'package:shopflow/features/orders/presentation/screens/checkout_screen.dart';
import 'package:shopflow/features/orders/presentation/screens/order_confirmation_screen.dart';
import 'package:shopflow/features/products/presentation/screens/product_category_screen.dart';
import 'package:shopflow/features/products/presentation/screens/product_home_screen.dart';
import 'package:shopflow/features/products/presentation/screens/product_detail_screen.dart';
import 'package:shopflow/features/products/presentation/screens/product_search_screen.dart';
import 'package:shopflow/features/wishlist/presentation/screens/product_wishlist_screen.dart';

class AppRouter {
  static final route = GoRouter(
    initialLocation: '/product-debug',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const Scaffold(
            body: Center(child: Text("ShopFlow\nApplication Shell")),
          );
        },
      ),

      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailScreen(productId: id);
        },
      ),

      GoRoute(
        path: '/product-debug',
        builder: (context, state) => const ProductDebugScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: ((context, state) => const ProductSearchScreen()),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const ProductCategoryScreen(),
      ),
      GoRoute(
        path: '/wishlist',
        builder: (context, state) => const ProductWishlistScreen(),
      ),
      GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/order-confirmation',
        builder: (context, state) => const OrderConfirmationScreen(),
      ),
    ],
  );
}
