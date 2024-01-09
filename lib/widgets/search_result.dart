import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:techstuff/models/product_model.dart';
import 'package:techstuff/widgets/product_card_widget.dart';

import '../screens/AppScreens/product_detail_screen.dart';

class SearchResults extends StatelessWidget {
  final String query;
  SearchResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.9,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot product = snapshot.data!.docs[index];
              final _productModel = Product(
                productID: product.id,
                imageURL: product['imageURL'],
                name: product['name'],
                description: product['description'],
                price: product['price'],
                discount: product['discount'],
                ratings: product['rating'],
                features: product['features'],
                reference: product.reference,
              );
              return snapshot.data == null
                  ? Center(
                      child: Text(
                        'No product found....',
                        style: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: _productModel),
                            ));
                      },
                      child: ProductCardWidget(
                        title: product['name'],
                        price: product['price'].toString(),
                        rating: product['rating'],
                        imageURL: product['imageURL'],
                        discount: product['discount'],
                      ),
                    );
            },
          );
          // return ListView.builder(
          //   itemCount: snapshot.data!.docs.length,
          //   itemBuilder: (context, index) {
          //     DocumentSnapshot product = snapshot.data!.docs[index];
          //     return ProductCardWidget(
          //         title: product['name'],
          //         price: product['price'].toString(),
          //         rating: product['rating'],
          //         imageURL: product['imageURL'],
          //         discount: product['discount']);
          //   },
          // );
        },
      ),
    );
  }
}
