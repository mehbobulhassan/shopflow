import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopflow/features/products/presentation/screens/product_category_screen.dart';
import 'package:shopflow/features/products/presentation/screens/product_debug_screen.dart';
import 'package:shopflow/features/products/presentation/screens/product_detail_screen.dart';
import 'package:shopflow/features/products/presentation/screens/product_search_screen.dart';

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
    ],
  );
}
