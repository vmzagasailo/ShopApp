import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context).settings.arguments as String;
    final productData =
        Provider.of<ProductsProvider>(context, listen: false).findById(prodId);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(productData.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: deviceSize.height * 0.5,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                productData.title,
                textAlign: TextAlign.center,
              ),
              background: Hero(
                tag: productData.id,
                child: Image.network(
                  productData.imageUrl,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 30),
                Text(
                  '\$${productData.price}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    productData.description,
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.8,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
