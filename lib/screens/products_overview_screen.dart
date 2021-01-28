import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

class ProductOverviewScrenn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('myShop'),
      ),
      body: ProductsGrid(),
    );
  }
}
