import 'dart:convert';

import 'package:http/http.dart';

import '../moduls/product.dart';

import 'package:flutter/material.dart';

class UpdateProductScreen extends StatefulWidget {
  const UpdateProductScreen({super.key, required this.product});

  static const name = '/update-product';
  final Product product;

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  bool _updateProductInProgress = false;
  GlobalKey<FormState> _fromkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.product.productName ?? '';
    _priceTEController.text = widget.product.unitPrice ?? '';
    _totalPriceTEController.text = widget.product.totalPrice ?? '';
    _quantityTEController.text = widget.product.quantity ?? '';
    _imageTEController.text = widget.product.image ?? '';
    _codeTEController.text = widget.product.productCode ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildProductForm(),
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Form(
      key: _fromkey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameTEController,
            decoration:
                InputDecoration(hintText: 'Name', labelText: 'Product Name'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _priceTEController,
            decoration:
                InputDecoration(hintText: 'Price', labelText: 'Product Price'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product Price';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _totalPriceTEController,
            decoration: InputDecoration(
                hintText: 'Total Price', labelText: 'Product Total Price'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product Total Price';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _quantityTEController,
            decoration: InputDecoration(
                hintText: 'Quantity', labelText: 'Product Quantity'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product Quantity';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _imageTEController,
            decoration:
                InputDecoration(hintText: 'Image', labelText: 'Product Image'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product Image';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _codeTEController,
            decoration:
                InputDecoration(hintText: 'Code', labelText: 'Product Code'),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter product Code';
              }
              return null;
            },
          ),
          TextFormField(),
          SizedBox(
            height: 30,
          ),
          Visibility(
            visible: _updateProductInProgress == false,
            replacement: Center(
              child: CircularProgressIndicator(),
            ),
            child: ElevatedButton(
              onPressed: () {
                _updateProduct();
              },
              child: Text('Update Product'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateProduct() async {
    _updateProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse(
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}');

    Map<String, dynamic> requestBody = {
      "ProductName": _nameTEController.text.trim(),
      "ProductCode": _codeTEController.text.trim(),
      "Img": _imageTEController.text.trim(),
      "UnitPrice": _priceTEController.text.trim(),
      "Qty": _quantityTEController.text.trim(),
      "TotalPrice": _totalPriceTEController.text.trim(),
    };
    Response response = await post(
      uri,
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    _updateProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('product has been updated'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('product update faild! Try again'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _codeTEController.dispose();
    _priceTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
    _quantityTEController.dispose();
    super.dispose();
  }
}
