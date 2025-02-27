import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/marker.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/cart.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: [
          Consumer<Cart>(
            child:
                IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
            builder: (ctx, cart, child) =>
                Marker(value: cart.itemsCount.toString(), child: child!),
          ),
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                PopupMenuItem(value: FilterOptions.all, child: Text('Todos')),
                PopupMenuItem(
                    value: FilterOptions.favorite, child: Text('Favoritos')),
              ];
            },
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
        ],
      ),
      body: ProductGrid(
        showFavoriteOnly: _showFavoriteOnly,
      ),
    );
  }
}
