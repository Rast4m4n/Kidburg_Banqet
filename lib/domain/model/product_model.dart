class ProductModel {
  ProductModel({
    required this.idRow,
    required this.nameProduct,
    required this.weight,
    required this.price,
    this.count,
  });
  final int idRow;
  final String? nameProduct;
  final String? weight;
  final int? count;
  final String? price;
}
