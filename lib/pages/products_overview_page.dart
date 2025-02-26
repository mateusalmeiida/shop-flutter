import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/product_grid.dart';
import 'package:shop/models/product_list.dart';

class ProductsOverviewPage extends StatelessWidget {
  const ProductsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                    value: 0,
                    child: Row(
                      children: [
                        Text('Somente Favoritos'),
                        Icon(
                            color: Colors.black,
                            provider.favorityOnly
                                ? Icons.check_box
                                : Icons.check_box_outline_blank)
                      ],
                    )),
              ];
            },
            onSelected: (_) {
              provider.showFavoriteToggle();
            },
          )
        ],
      ),
      body: ProductGrid(),
    );
  }
}
