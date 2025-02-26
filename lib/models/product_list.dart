import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  bool _showFavoriteOnly = false;

  List<Product> get items {
    if (!_showFavoriteOnly) {
      return [..._items];
    } else {
      return [
        ..._items.where((item) {
          return item.isFavorite;
        })
      ];
    }
  }

  bool get favorityOnly {
    return _showFavoriteOnly;
  }

  void showFavoriteToggle() {
    _showFavoriteOnly = !_showFavoriteOnly;
    notifyListeners();
  }

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
