import 'package:flutter/material.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/products_overview_page.dart';
import 'package:shop/utils/app_routes.dart';

void main() {
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'Lato',
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white,
              primary: Colors.deepPurple,
              secondary: Colors.deepOrange),
          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
          ),
          textTheme: TextTheme(
              titleSmall: TextStyle(fontFamily: 'Lato', color: Colors.white))),
      title: 'Minha Loja',
      debugShowCheckedModeBanner: false,
      home: ProductsOverviewPage(),
      routes: {
        AppRoutes.PRODUCT_DETAIL: (ctx) {
          return ProductDetailPage();
        }
      },
    );
  }
}
