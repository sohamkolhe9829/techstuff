import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class CartProvider extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  getUserData() {
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then(
      (value) {
        loggedInUser = UserModel.fromMap(value.data());
      },
    );
  }

  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  maximizeCart(CartItem cartItem) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('carts')
        .doc(cartItem.productID)
        .get();
    final cart = snapshot.data() as Map<String, dynamic>;
    final quantity = cart['quantity'] + 1;
    await FirebaseFirestore.instance
        .collection('carts')
        .doc(cartItem.productID)
        .update({
      'quantity': quantity,
    });
    notifyListeners();
  }

  minimizeCart(CartItem cartItem) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('carts')
        .doc(cartItem.productID)
        .get();
    final cart = snapshot.data() as Map<String, dynamic>;

    if (cart['quantity'] == 1) {
      removeFromCart(cartItem.productID);
    } else {
      final quantity = cart['quantity'] - 1;
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(cartItem.productID)
          .update({
        'quantity': quantity,
      });
    }

    notifyListeners();
  }

  addToCart(CartItem cartItem) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('carts')
        .doc(cartItem.productID)
        .get();
    if (snapshot.exists) {
      final cart = snapshot.data() as Map<String, dynamic>;
      final quantity = cart['quantity'] + 1;
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(cartItem.productID)
          .update({
        'quantity': quantity,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(cartItem.productID)
          .set({
        'userID': user!.uid,
        'productId': cartItem.product.productID,
        'quantity': cartItem.quantity,
        'name': cartItem.product.name,
        'price': cartItem.product.price,
        'imageURL': cartItem.product.imageURL,
        'discount': cartItem.product.discount,
        'features': cartItem.product.features,
        'rating': cartItem.product.ratings,
      });
    }
    _cartItems.add(cartItem);
    notifyListeners();
  }

  loadCartItems() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('carts')
        .where('userID', isEqualTo: '${user!.uid}')
        .get();
    _cartItems = snapshot.docs
        .map(
          (doc) => CartItem(
            productID: doc.id,
            product: Product(
              productID: doc['productId'],
              name: doc['name'],
              description: '',
              price: doc['price'],
              reference: FirebaseFirestore.instance
                  .doc('products/${doc['productId']}'),
              imageURL: doc['imageURL'],
              discount: doc['discount'],
              features: doc['features'],
              ratings: doc['rating'],
            ),
            quantity: doc['quantity'],
          ),
        )
        .toList();
    notifyListeners();
  }

  removeFromCart(String cartItemId) async {
    _cartItems.removeWhere((item) => item.productID == cartItemId);
    notifyListeners();
    await FirebaseFirestore.instance
        .collection('carts')
        .doc(cartItemId)
        .delete();
    notifyListeners();
  }

  getPriceSummaryCart() {
    var price = 0;
    List<int> prices = [];
    int finalPrice = 0;
    for (int i = 0; i < _cartItems.length; i++) {
      int price = _cartItems[i].product.price;

      double demoPrice = price / 100;
      double discountPrice = demoPrice * _cartItems[i].product.discount;

      int finalPrice = price - discountPrice.toInt();

      int getPrice = finalPrice * _cartItems[i].quantity;
      prices.add(getPrice);
    }

    for (int i = 0; i < prices.length; i++) {
      finalPrice = finalPrice + prices[i];
    }

    return finalPrice;
  }
}
