import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = [];
  final _baseUrl =
      'https://shop-flutter-74e45-default-rtdb.firebaseio.com/products';

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
      Uri.parse('$_baseUrl.json'),
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

  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) {
      return p.id == product.id;
    });

    if (index >= 0) {
      final Product product = _items[index];

      _items.remove(product);
      notifyListeners();

      final response = await delete(Uri.parse('$_baseUrl/${product.id}.json'));

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpExceptions(
            msg: 'Não foi possível excluir o produto',
            statusCode: response.statusCode);
      }
    }
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await get(Uri.parse('$_baseUrl.json'));
    if (response.body == 'null') {
      return;
    }
    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      _items.add(Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite']));
    });
    notifyListeners();
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

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) {
      return p.id == product.id;
    });

    if (index >= 0) {
      await patch(
        Uri.parse('$_baseUrl/${product.id}.json'),
        body: jsonEncode(
          {
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }
}
