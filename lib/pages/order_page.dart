import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order_widget.dart';
import 'package:shop/models/order_list.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: orders.itemsCount,
          itemBuilder: (ctx, index) {
            return OrderWidget(order: orders.items[index]);
          }),
    );
  }
}
