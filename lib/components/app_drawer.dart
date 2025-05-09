import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              title: Text('Bem vindo!'),
              automaticallyImplyLeading: false,
            ),
            ListTile(
                leading: Icon(Icons.shop),
                title: Text('Loja'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.AUTH_OR_HOME);
                }),
            Divider(),
            ListTile(
                leading: Icon(Icons.payment),
                title: Text('Pedidos'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
                }),
            Divider(),
            ListTile(
                leading: Icon(Icons.edit),
                title: Text('Gerenciar Produtos'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutes.PRODUCTS);
                }),
            Divider(),
            ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sair'),
                onTap: () {
                  Provider.of<Auth>(context, listen: false).logout();
                  Provider.of<Cart>(context, listen: false).clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.AUTH_OR_HOME, (route) => false);
                }),
          ],
        ),
      ),
    );
  }
}
