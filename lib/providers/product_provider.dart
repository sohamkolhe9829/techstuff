import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  void loadProducts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('rating', isGreaterThanOrEqualTo: 4)
        .get();
    _products = snapshot.docs
        .map((doc) => Product(
              productID: doc.id,
              imageURL: doc['imageURL'],
              name: doc['name'],
              description: doc['description'],
              price: doc['price'],
              discount: doc['discount'],
              ratings: doc['rating'],
              features: doc['features'],
              reference: doc.reference,
            ))
        .toList();
    notifyListeners();
  }
}
