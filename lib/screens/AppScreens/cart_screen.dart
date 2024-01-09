import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techstuff/providers/cart_provider.dart';
import 'package:techstuff/screens/AppScreens/cart_checkout_screen.dart';
import 'package:techstuff/screens/AppScreens/product_detail_screen.dart';

import '../../constants/colors.dart';
import '../../models/cart_model.dart';
import '../../widgets/custom_appbar.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    setState(() {});
    super.initState();
    setState(() {});
    _reload();
  }

  void _reload() async {
    Timer(Duration(milliseconds: 200), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _cartProvider.loadCartItems();

    int deliveryCharges = 0;

    for (var i = 0; i < _cartProvider.cartItems.length; i++) {
      deliveryCharges =
          (_cartProvider.cartItems[i].product.price <= 500 ? 40 : 00) +
              deliveryCharges;
    }

    setState(() {});
    setState(() {});

    return Scaffold(
      appBar: CustomAppbar(title: 'My Cart', ctx: context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(
                      Duration(seconds: 1),
                      () {
                        setState(() {});

                        // showing snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Page refreshed")));
                      },
                    );
                  },
                  child: _cartProvider.cartItems.length == 0
                      ? Center(
                          child: Text(
                            "There is no item in cart.....",
                            style: TextStyle(fontSize: 19),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _cartProvider.cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = _cartProvider.cartItems[index];
                            var demoPrice = cartItem.product.price / 100;
                            var discountPrice =
                                demoPrice * cartItem.product.discount;
                            int finalPrice =
                                cartItem.product.price - discountPrice.toInt();
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                          product: cartItem.product),
                                    ));
                              },
                              child: CartProductCard(
                                context,
                                cartItem.product.imageURL,
                                cartItem.product.name,
                                finalPrice,
                                cartItem.quantity,
                                () async {
                                  await _cartProvider.minimizeCart(cartItem);
                                  setState(() {});
                                  _reload();
                                  _reload();
                                },
                                () async {
                                  await _cartProvider.maximizeCart(cartItem);
                                  setState(() {});
                                  _reload();
                                  _reload();
                                },
                                () async {
                                  await _cartProvider
                                      .removeFromCart(cartItem.productID);
                                  setState(() {});
                                },
                              ),
                            );
                          },
                        ),
                ),
              ),
              SizedBox(height: 10),
              PriceSummary(context, _cartProvider.getPriceSummaryCart(),
                  deliveryCharges, _cartProvider.cartItems),
            ],
          ),
        ),
      ),
    );
  }

  PriceSummary(
    context,
    var subTotal,
    int shippingCharge,
    List<CartItem> CartItems,
  ) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 185,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: customWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Price Summary",
            style: TextStyle(
                color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sub Total:",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                width: 85,
                child: Text(
                  "₹ ${subTotal}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width / 2 + 100,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Shipping Charge:",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(
                width: 85,
                child: Text(
                  "₹ $shippingCharge",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CartCheckOutScreen(cartItems: CartItems),
                  ));
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: customBlack,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '₹ ${subTotal + shippingCharge}',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: ' Check Out',
                        style: TextStyle(
                          color: customWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                // child: Text(
                //   "Check Out",
                //   style: TextStyle(
                //       color: customWhite,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20),
                // ),
              ),
            ),
          )
        ],
      ),
    );
  }

  CartProductCard(
    context,
    String imageURL,
    String title,
    int finalPrice,
    int quantity,
    Function() minimizeCart,
    Function() maximizeCart,
    Function() removeFromCart,
  ) {
    return Column(
      children: [
        Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(10),
            height: 168,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: customWhite,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: customWhite,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.grey, blurRadius: 10),
                        ],
                      ),
                      height: 100,
                      width: 100,
                      child: Image.network(
                        '$imageURL',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$title",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "₹ $finalPrice",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            finalPrice >= 500 ? "Free Shipping" : '₹ 40',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.greenAccent[400],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: minimizeCart,
                            icon: Icon(Icons.remove_circle)),
                        Text(
                          quantity.toString(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                            onPressed: maximizeCart,
                            icon: Icon(Icons.add_circle_rounded)),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(customBlack),
                      ),
                      onPressed: removeFromCart,
                      icon: Icon(Icons.delete_outline_outlined),
                      label: Text(
                        "Remove",
                        style: TextStyle(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
