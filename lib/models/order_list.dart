import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/order.dart';
import 'package:shop/utils/constants.dart';

class OrderList with ChangeNotifier {
  final String token;
  final String userId;
  List<Order> _items;

  OrderList([this.token = '', this._items = const [], this.userId = '']);

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadOrders() async {
    List<Order> items = [];
    final response = await get(
        Uri.parse('${Constants.ORDER_BASE_URL}/$userId.json?auth=$token'));
    if (response.body == 'null') {
      return;
    }
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((orderId, orderData) {
      items.add(Order(
          id: orderId,
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
                id: item['id'],
                productId: item['productId'],
                name: item['name'],
                quantity: item['quantity'],
                price: item['price']);
          }).toList(),
          date: DateTime.parse(orderData['date'])));
    });
    _items = items.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    await post(
      Uri.parse('${Constants.ORDER_BASE_URL}/$userId.json?auth=$token'),
      body: jsonEncode({
        'total': cart.totalAmount,
        'date': date.toIso8601String(),
        'products': cart.items.values.map((cartItem) {
          return {
            'id': cartItem.id,
            'productId': cartItem.productId,
            'name': cartItem.name,
            'quantity': cartItem.quantity,
            'price': cartItem.price,
          };
        }).toList()
      }),
    );
  }
}
