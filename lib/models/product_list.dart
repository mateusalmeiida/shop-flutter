import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/exceptions/http_exceptions.dart';
import 'package:shop/models/product.dart';
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  String token;
  String userId;
  final List<Product> _items;

  List<Product> get items {
    return [..._items];
  }

  ProductList([this.token = '', this._items = const [], this.userId = '']);

  List<Product> get favoriteItems {
    return [
      ..._items.where((item) {
        return item.isFavorite;
      })
    ];
  }

  Future<void> addProduct(Product product) async {
    final response = await post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$token'),
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

      final response = await delete(Uri.parse(
          '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$token'));

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
    final response =
        await get(Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$token'));
    if (response.body == 'null') {
      return;
    }

    final favResponse = await get(
      Uri.parse('${Constants.USER_FAVORITES_URL}/$userId.json?auth=$token'),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final bool isFavorite = favData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
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
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$token'),
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
