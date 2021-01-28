import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    Key key,
    @required this.productList,
  }) : super(key: key);

  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: productList.length,
      itemBuilder: (ctx, index) => ProductItem(
        productList[index].id,
        productList[index].title,
        productList[index].imageUrl,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}