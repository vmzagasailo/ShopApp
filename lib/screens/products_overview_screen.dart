import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

import './cart_screen.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum ProductsFilter {
  Favorites,
  All,
}

class ProductOverviewScrenn extends StatefulWidget {
  @override
  _ProductOverviewScrennState createState() => _ProductOverviewScrennState();
}

class _ProductOverviewScrennState extends State<ProductOverviewScrenn> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('myShop'),
        actions: [
          PopupMenuButton(
            onSelected: (ProductsFilter selectedValue) {
              setState(() {
                if (selectedValue == ProductsFilter.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show favorites products'),
                value: ProductsFilter.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show all products'),
                value: ProductsFilter.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemsCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
