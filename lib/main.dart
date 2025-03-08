import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/pages/auth_or_home_page.dart';
import 'package:shop/pages/cart_page.dart';
import 'package:shop/pages/order_page.dart';
import 'package:shop/pages/product_detail_page.dart';
import 'package:shop/pages/product_form_page.dart';
import 'package:shop/pages/products_page.dart';
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
          return Auth();
        }),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) {
            return ProductList('', []);
          },
          update: (ctx, auth, previous) {
            return ProductList(auth.token ?? '', previous?.items ?? []);
          },
        ),
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
          AppRoutes.AUTH_OR_HOME: (ctx) {
            return AuthOrHomePage();
          },
          AppRoutes.PRODUCT_DETAIL: (ctx) {
            return ProductDetailPage();
          },
          AppRoutes.CART_PAGE: (ctx) {
            return CartPage();
          },
          AppRoutes.ORDERS: (ctx) {
            return OrderPage();
          },
          AppRoutes.PRODUCTS: (ctx) {
            return ProductsPage();
          },
          AppRoutes.PRODUCT_FORM: (ctx) {
            return ProductFormPage();
          }
        },
      ),
    );
  }
}
