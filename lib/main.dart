import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/order_page.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return ProductList();
        }),
        ChangeNotifierProvider(create: (_) {
          return Cart();
        }),
        ChangeNotifierProvider(create: (_) {
          return OrderList();
        }),
      ],
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.white,
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                secondary: Colors.deepOrange),
            appBarTheme: AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            textTheme: TextTheme(
                titleSmall:
                    TextStyle(fontFamily: 'Lato', color: Colors.white))),
        title: 'Minha Loja',
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.HOME: (ctx) {
            return ProductsOverviewPage();
          },
          AppRoutes.PRODUCT_DETAIL: (ctx) {
            return ProductDetailPage();
          },
          AppRoutes.CART_PAGE: (ctx) {
            return CartPage();
          },
          AppRoutes.ORDERS: (ctx) {
            return OrderPage();
          }
        },
      ),
    );
  }
}
