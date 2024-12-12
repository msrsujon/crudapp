class Product {
  String? id;
  String? productName;
  String? productCode;
  String? image;
  String? unitPrice;
  String? quantity;
  String? totalPrice;
  String? createdDate;

  Product(
      {this.productName,
      this.productCode,
      this.id,
      this.image,
      this.createdDate,
      this.totalPrice,
      this.unitPrice,
      this.quantity});
}
