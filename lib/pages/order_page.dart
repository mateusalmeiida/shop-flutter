import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order_widget.dart';
import 'package:shop/models/order_list.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool _isLoading = true;
  Future<void> _refreshOrder(BuildContext context) {
    return Provider.of<OrderList>(context, listen: false).loadOrders();
  }

  @override
  void initState() {
    super.initState();
    Provider.of<OrderList>(context, listen: false).loadOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          return _refreshOrder(context);
        },
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : orders.itemsCount == 0
                ? Center(
                    child: ListView(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height -
                              kToolbarHeight -
                              MediaQuery.of(context).padding.top,
                          alignment: Alignment.center,
                          child: Text(
                            'Você não tem pedidos no histórico',
                            style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 16,
                                color: Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (ctx, index) {
                      return OrderWidget(order: orders.items[index]);
                    }),
      ),
    );
  }
}
