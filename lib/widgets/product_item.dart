import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth_provider.dart';

import 'package:shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Container(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        header: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                product.toggleFavoriteStatus(
                  authData.token,
                  authData.userId,
                );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                  content: Text(
                    'Added item to cart',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            //product.price.toString(),
            '',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
