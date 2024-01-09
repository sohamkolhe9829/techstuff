import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String productID;
  String imageURL;
  String name;
  String description;
  int price;
  int discount;
  int ratings;
  List features;
  DocumentReference reference;

  Product({
    required this.productID,
    required this.imageURL,
    required this.name,
    required this.description,
    required this.price,
    required this.discount,
    required this.ratings,
    required this.features,
    required this.reference,
  });
}
