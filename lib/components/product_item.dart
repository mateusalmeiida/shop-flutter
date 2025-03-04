import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
                },
                icon: Icon(Icons.edit)),
            IconButton(
                color: Theme.of(context).colorScheme.primary,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text('Tem certeza?'),
                          content: Text(
                              'Deseja mesmo excluir esse produto da sua loja?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Provider.of<ProductList>(context,
                                          listen: false)
                                      .removeProduct(product);
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('Sim')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('Não'))
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete))
          ],
        ),
      ),
    );
  }
}
