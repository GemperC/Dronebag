import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dronebag/providers/shopping_cart_provider.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dronebag'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('${context.watch<ShoppingCart>().count}'),
            Text('${context.watch<ShoppingCart>().cart}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: Key('addItem_floatingActionButton'),
        onPressed: () => context.read<ShoppingCart>().addItem('Bread'),
        tooltip: 'Add Item',
        child: Icon(Icons.add),
      ),
    );
  }
}
