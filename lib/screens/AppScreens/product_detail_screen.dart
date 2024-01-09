import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techstuff/models/cart_model.dart';
import 'package:techstuff/models/product_model.dart';
import 'package:techstuff/providers/cart_provider.dart';

import '../../constants/colors.dart';
import '../../providers/order_provider.dart';
import 'checkout_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  Product product;
  ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // var demoPrice = docID.get('price') / 100;
    // double discountPrice = demoPrice * docID.get('discount');
    // var rating = docID.get('rating');
    User? user = FirebaseAuth.instance.currentUser;

    final _cartProvider = Provider.of<CartProvider>(context, listen: false);

    var demoPrice = widget.product.price / 100;
    double discountPrice = demoPrice * widget.product.discount;
    var rating = widget.product.ratings;

    List features = widget.product.features;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 500,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    '${widget.product.imageURL}',
                    fit: BoxFit.fitWidth,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text(
                        // "Zebronics Zeb-Transformer-M Optical USB Gaming Mouse with LED Effect(Black)",
                        "${widget.product.name}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.product.price}  ",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough),
                          ),
                          Text(
                            "₹ ${widget.product.price - discountPrice.toInt()}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            ' ${widget.product.discount}% off',
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${widget.product.description}",
                        style: TextStyle(color: Colors.grey, fontSize: 17),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        color: customGrey,
                        // height: 170,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Product Highlights",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var i in features)
                                  Text(
                                    "${i.toString()}",
                                    style: TextStyle(fontSize: 17),
                                  ),

                                // SizedBox(height: 5),
                                // Text(
                                //   "Gaming Keyboard",
                                //   style: TextStyle(fontSize: 17),
                                // ),
                                // SizedBox(height: 5),
                                // Text(
                                //   "Great plastic build",
                                //   style: TextStyle(fontSize: 17),
                                // ),
                                // SizedBox(height: 5),
                                // Text(
                                //   "Semi- Mechanical Keyboard",
                                //   style: TextStyle(fontSize: 17),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        rating >= 1
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                        rating >= 2
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                        rating >= 3
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                        rating >= 4
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                        rating == 5
                            ? Icon(Icons.star)
                            : Icon(Icons.star_border),
                      ],
                    ),
                    Container(
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: customBlack,
                      ),
                      child: IconButton(
                        onPressed: () {
                          int click = 0;

                          click == 0
                              ? _cartProvider.addToCart(
                                  CartItem(
                                    productID: widget.product.productID,
                                    product: widget.product,
                                  ),
                                )
                              : null;
                          setState(() {
                            click++;
                          });

                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content: Text('Item added to Cart'),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add_shopping_cart_outlined,
                          color: customWhite,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(customBlack),
                      ),
                      icon: Icon(Icons.shopping_bag_outlined),
                      onPressed: () {
                        final _orderProvider =
                            Provider.of<OrderProvider>(context, listen: false);
                        _orderProvider.loadOrderItems();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CheckOutScreen(product: widget.product),
                            ));
                      },
                      label: Text("Order Now"),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
