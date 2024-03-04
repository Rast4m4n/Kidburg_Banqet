class ProductModel {
  ProductModel({
    required this.nameProduct,
    required this.weight,
    required this.price,
    this.count,
    this.totalPrice,
  });

  final String? nameProduct;
  final String? weight;
  final int? count;
  final String? price;
  final int? totalPrice;
}
