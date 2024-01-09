import 'package:techstuff/models/product_model.dart';

class OrderItem {
  String productID;
  Product product;
  String status;
  int orderPrice;
  String contact;
  String paymentMethod;
  String userName;
  int orderID;
  int? quantity;

  String address;

  OrderItem({
    required this.productID,
    required this.product,
    required this.orderID,
    required this.status,
    required this.orderPrice,
    required this.paymentMethod,
    required this.address,
    required this.userName,
    required this.contact,
    this.quantity,
  });
}
