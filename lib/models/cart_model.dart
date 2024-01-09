import 'package:techstuff/models/product_model.dart';

class CartItem {
  String productID;
  Product product;
  int quantity;

  CartItem({
    required this.productID,
    required this.product,
    this.quantity = 1,
  });
}
