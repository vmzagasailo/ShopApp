import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

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
        ],
      ),
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
