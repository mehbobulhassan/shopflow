import 'package:flutter/material.dart';
import 'package:shopflow/core/routing/app_router.dart';
import 'package:shopflow/core/theme/app_theme.dart';

class ShopFlowApp extends StatelessWidget {
  const ShopFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ShopFlow',
      theme: AppTheme.light,
      routerConfig: AppRouter.route,
    );
  }
}
