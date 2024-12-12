import 'dart:convert';

import 'package:crudapp/ui/screens/add_new_product_screen.dart';
import 'package:flutter/material.dart';
import '../moduls/product.dart';
import '../widgets/product_item.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  static const String name = '/add-new-product';

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _getProductListInProgress = false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(
            onPressed: () {
              _getProductList();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getProductList();
        },
        child: Visibility(
          visible: _getProductListInProgress == false,
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return ProductItem(
                product: productList[index],
                onDeleteTab: () {
                  _deleteItemDialog(productList[index], index);
                  setState(
                    () {},
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewProductScreen.name);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async {
    productList.clear();
    _getProductListInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      print(decodedData['status']);
      for (Map<String, dynamic> p in decodedData['data']) {
        Product product = Product(
          id: p['_id'],
          productName: p['ProductName'],
          productCode: p['ProductCode'],
          unitPrice: p['UnitPrice'],
          totalPrice: p['TotalPrice'],
          image: p['Img'],
          quantity: p['Qty'],
          createdDate: p['CreatedDate'],
        );
        productList.add(product);
      }
      setState(() {});
    }
    _getProductListInProgress = false;
  }

  // delete here
  void _deleteItemDialog(Product product, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure? Will you delete this product?'),
          backgroundColor: Colors.green,
          content: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: Colors.green)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Image(
                    height: 80,
                    width: 60,
                    image: NetworkImage('${product.image}'),
                    errorBuilder: (context, error, stackTrace) {
                      return Image.network(
                          'https://static.thenounproject.com/png/1211233-200.png');
                    },
                  ),
                  title: Text(product.productName ?? ''),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product Code: ${product.productCode ?? ''}'),
                      Text('Quantity:  ${product.quantity ?? ''}'),
                      Text('Price:  ${product.unitPrice ?? ''}'),
                      Text('Total Price:  ${product.totalPrice ?? ''}'),
                    ],
                  ),
                  tileColor: Colors.green,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey)),
              child: const Text(
                'NO',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  _deletedProduct('${product.id}', index);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: const Text(
                  'YES',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        );
      },
    );
  }

  /// Delete Product API Call
  Future<void> _deletedProduct(String ID, int index) async {
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/$ID');
    Response response = await get(uri);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete confirm'),
        ),
      );

      productList.removeAt(index);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleting process "False" ID:$ID'),
        ),
      );
    }
    setState(() {});
  }
}
