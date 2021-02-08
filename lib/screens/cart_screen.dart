import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';

import '../widgets/cart_item.dart' as ci;

class CartScreen extends StatelessWidget {
  static const routeName = 'cart-screen';
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(12),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartData.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cartData: cartData)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartData.items.length,
              itemBuilder: (ctx, i) => ci.CartItem(
                id: cartData.items.values.toList()[i].id,
                prodId: cartData.items.keys.toList()[i],
                price: cartData.items.values.toList()[i].price,
                quntity: cartData.items.values.toList()[i].quantity,
                title: cartData.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cartData.totalAmount <= 0
          ? null
          : () {
              Provider.of<Orders>(context, listen: false).addOrder(
                widget.cartData.items.values.toList(),
                widget.cartData.totalAmount,
              );
              widget.cartData.clear();
            },
      child: Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
