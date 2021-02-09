import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products_provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_items.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'order-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _orders;
  Future _getOrders() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }
  @override
  void initState() {
    _orders = _getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('Orders'),
        ),
        body: FutureBuilder(
          future: _orders,
          builder: (ctx, dataSnapshots) {
            if (dataSnapshots.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshots.error != null) {
                // error handling
                return Center(
                  child: Text('something wrong...'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, ordersData, child) => ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(ordersData.orders[i]),
                  ),
                );
              }
            }
          },
        ));
  }
}
