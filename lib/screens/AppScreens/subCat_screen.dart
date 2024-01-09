import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:techstuff/screens/AppScreens/product_detail_screen.dart';
import 'package:techstuff/widgets/product_card_widget.dart';

import '../../constants/colors.dart';
import '../../models/product_model.dart';

class SubCatScreen extends StatefulWidget {
  String? title;
  String? category;
  SubCatScreen({
    this.title,
    this.category,
  });

  @override
  State<SubCatScreen> createState() => _SubCatScreenState();
}

class _SubCatScreenState extends State<SubCatScreen> {
  List<dynamic> docIDDemo = [];
  List<String> docIDs = [];
  String itemByName = '';

  Future<void> getDocId() async {
    await FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.category)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIDDemo.add(document.reference.id);
              setState(() {});
              docIDs = docIDDemo.map((e) => e.toString()).toList();
            },
          ),
        );
  }

  @override
  void initState() {
    super.initState();
    getDocId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlack,
        title: Text(
          widget.title!,
          style: TextStyle(
            color: customWhite,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: docIDs.length,
              itemBuilder: (BuildContext ctx, index) {
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .doc(docIDs[index])
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('We are getting some error!!!'),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      final _productModel = Product(
                        productID: snapshot.data!.get('productID'),
                        imageURL: snapshot.data!.get('imageURL'),
                        name: snapshot.data!.get('name'),
                        description: snapshot.data!.get('description'),
                        price: snapshot.data!.get('price'),
                        discount: snapshot.data!.get('discount'),
                        ratings: snapshot.data!.get('rating'),
                        features: snapshot.data!.get('features'),
                        reference: snapshot.data!.reference,
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
                                      builder: (context) => ProductDetailScreen(
                                          product: _productModel),
                                    ));
                              },
                              child: ProductCardWidget(
                                title: snapshot.data!.get('name'),
                                price: snapshot.data!.get('price').toString(),
                                rating: snapshot.data!.get('rating'),
                                imageURL: snapshot.data!.get('imageURL'),
                                discount: snapshot.data!.get('discount'),
                              ),
                            );
                    }
                  },
                );
              }),
        ),
      ),
    );
  }
}
