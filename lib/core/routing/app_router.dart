import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shopflow/features/products/presentation/screens/product_debug_screen.dart';

class AppRouter {
  static final route = GoRouter(
    initialLocation: "/product-debug",
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return Scaffold(
            body: Center(child: Text("ShopFlow\nApplication Shell")),
          );
        },
      ),
      GoRoute(
        path: "/product-debug",
        builder: (context, state) => const ProductDebugScreen(),
      ),
    ],
  );
}
