import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final route = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return Scaffold(
            body: Center(child: Text("ShopFlow\nApplication Shell"),),
          );
        },
      ),
    ],
  );
}
