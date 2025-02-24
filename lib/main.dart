import 'package:flutter/material.dart';
import 'package:shop/pages/products_overview_page.dart';

void main() {
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      )),
      title: 'Minha Loja',
      debugShowCheckedModeBanner: false,
      home: ProductsOverviewPage(),
    );
  }
}
