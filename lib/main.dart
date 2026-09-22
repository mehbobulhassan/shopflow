import 'package:flutter/material.dart';

void main() {
  runApp(const ShopFlow());
}

class ShopFlow extends StatelessWidget {
  const ShopFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopFlow',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(body: const Center(child: Text("ShowFlow"),),);
  }
}
