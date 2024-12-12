import 'package:flutter/material.dart';
import '../moduls/product.dart';
import '../screens/update_product_screen.dart';

class ProductItem extends StatelessWidget {
  ProductItem({super.key, required this.product, this.onDeleteTab});

  final Product product;
  VoidCallback? onDeleteTab;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        product.image ?? '',
        width: 40,
      ),
      title: Text(product.productName ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${product.productCode ?? ''}'),
          Text('Quantity: ${product.quantity ?? ''}'),
          Text('Price: ${product.unitPrice ?? ''}'),
          Text('Total Price: ${product.totalPrice ?? ''}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: onDeleteTab,
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                UpdateProductScreen.name,
                arguments: product,
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
