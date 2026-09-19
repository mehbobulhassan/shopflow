import 'package:flutter/material.dart';

void main() {
  runApp(const ShopFlow());
}

class ShopFlow extends StatelessWidget {
  const ShopFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Flow',
      home: const Text("Shop Flow"),
    );
  }
}
