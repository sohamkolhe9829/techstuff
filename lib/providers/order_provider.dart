import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:techstuff/models/order_model.dart';

import '../models/product_model.dart';
import '../models/user_model.dart';

class OrderProvider extends ChangeNotifier {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  getUserData() {
    FirebaseFirestore.instance.collection("users").doc(user!.uid).get().then(
      (value) {
        loggedInUser = UserModel.fromMap(value.data());
      },
    );
  }

  List<OrderItem> _orderItems = [];

  List<OrderItem> get orderItems => _orderItems;

  bool isPrepaid = false;

  int orderPrice = 0;

  addToOrder(OrderItem orderItem) async {
    await FirebaseFirestore.instance.collection('orders').add({
      'userID': user!.uid,
      'paymentMethod': isPrepaid ? 'Prepaid' : 'Postpaid',
      'address': loggedInUser.address,
      'email': loggedInUser.email,
      'contact': loggedInUser.contact,
      'userName': loggedInUser.name,
      'productId': orderItem.product.productID,
      'name': orderItem.product.name,
      'price': orderItem.product.price,
      'orderPrice': orderItem.orderPrice,
      'imageURL': orderItem.product.imageURL,
      'discount': orderItem.product.discount,
      'features': orderItem.product.features,
      'rating': orderItem.product.ratings,
      'quantity': orderItem.quantity,
      'orderDate': DateTime.now(),
      'status': 'Order Placed',
      'statusTime': DateTime.now(),
      'orderID': Random().nextInt(999999),
    });

    _orderItems.add(orderItem);
    notifyListeners();
  }

  loadOrderItems() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userID', isEqualTo: '${user!.uid}')
        .get();
    _orderItems = snapshot.docs
        .map(
          (doc) => OrderItem(
            orderID: doc['orderID'],
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
            status: doc['status'],
            orderPrice: doc['orderPrice'],
            quantity: doc['quantity'],
            paymentMethod: doc['paymentMethod'],
            address: doc['address'],
            userName: doc['userName'],
            contact: doc['contact'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
