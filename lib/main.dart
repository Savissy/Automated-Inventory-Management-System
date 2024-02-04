import 'package:flutter/material.dart';

import 'package:inventory_management/screens/customer_module.dart';
import 'package:inventory_management/screens/order_module.dart';
import 'package:inventory_management/screens/order_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const OrderModule(),
    );
  }
}
