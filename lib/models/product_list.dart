import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  final _baseUrl = 'https://shop-flutter-74e45-default-rtdb.firebaseio.com';

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return [
      ..._items.where((item) {
        return item.isFavorite;
      })
    ];
  }

  Future<void> addProduct(Product product) async {
    final response = await post(
      Uri.parse('$_baseUrl/products.json'),
      body: jsonEncode(
        {
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
    );
    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl));
    notifyListeners();
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) {
      return p.id == product.id;
    });

    if (index >= 0) {
      _items.removeWhere((p) {
        return p.id == product.id;
      });
      notifyListeners();
    }
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;
    final product = Product(
        id: hasId ? data['id'] as String : Random().nextDouble().toString(),
        name: data['name'] as String,
        description: data['description'] as String,
        price: data['price'] as double,
        imageUrl: data['url'] as String);

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((p) {
      return p.id == product.id;
    });

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }
}
