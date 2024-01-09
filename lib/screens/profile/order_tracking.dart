import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techstuff/screens/AppScreens/product_detail_screen.dart';
import 'package:techstuff/widgets/custom_appbar.dart';

import '../../constants/colors.dart';
import '../../models/order_model.dart';
import '../../models/user_model.dart';
import '../../providers/order_provider.dart';

class OrderTracking extends StatefulWidget {
  OrderItem orderItem;
  OrderTracking({super.key, required this.orderItem});

  @override
  State<OrderTracking> createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _orderProvider = Provider.of<OrderProvider>(context, listen: false);
    _orderProvider.getUserData();

    double demoPrice = widget.orderItem.product.price / 100;
    double discountPrice = demoPrice * widget.orderItem.product.discount;

    int finalPrice = widget.orderItem.product.price - discountPrice.toInt();

    int getPrice = finalPrice * widget.orderItem.quantity!;

    reload() {
      Timer(Duration(milliseconds: 400), () {
        _orderProvider.loadOrderItems();
      });
    }

    return Scaffold(
      appBar: CustomAppbar(title: 'Track Order', ctx: context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                              product: widget.orderItem.product)));
                },
                child: TrackOrderCard(
                  context,
                  widget.orderItem.product.imageURL,
                  widget.orderItem.product.name,
                  getPrice,
                  widget.orderItem.product.discount,
                ),
              ),
              SizedBox(height: 10),
              orderSummary(),
              SizedBox(height: 10),
              trackingCard(context, widget.orderItem.status),
              SizedBox(height: 10),
              addressCard(
                context,
                _orderProvider.loggedInUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  orderSummary() {
    return Card(
      elevation: 5,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[400],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: customBlack),
                      children: [
                        TextSpan(
                          text: 'Order ID: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: widget.orderItem.orderID.toString(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: customBlack),
                      children: [
                        TextSpan(
                          text: 'Quantity: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: widget.orderItem.quantity.toString(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: customBlack),
                      children: [
                        TextSpan(
                          text: 'Payable Price: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '₹ ' + widget.orderItem.orderPrice.toString(),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TrackOrderCard(
    context,
    String imageURL,
    String title,
    int price,
    int discount,
  ) {
    return Column(
      children: [
        Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(10),
            height: 120,
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
                            "₹ $price",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "$discount% off",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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

  addressCard(context, UserModel loggedInUser) {
    return Card(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Address",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[400],
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "${loggedInUser.name}\n",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: customBlack,
                      ),
                    ),
                    TextSpan(
                      text: "${loggedInUser.contact} / ${loggedInUser.email}\n",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: customBlack,
                      ),
                    ),
                    TextSpan(
                      text: loggedInUser.address,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: customBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  trackingCard(context, String status) {
    return Card(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.green, maxRadius: 10),
                  SizedBox(width: 10),
                  Text(
                    "Order Placed",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 9),
                color: Colors.green,
                width: 2,
                height: 100,
              ),
              Row(
                children: [
                  CircleAvatar(
                      backgroundColor: status == 'Shipped'
                          ? Colors.green
                          : status == 'Out for delivery'
                              ? Colors.green
                              : status == 'Delivered'
                                  ? Colors.green
                                  : Colors.grey,
                      maxRadius: 10),
                  SizedBox(width: 10),
                  Text(
                    "Shipped",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 9),
                color: status == 'Shipped'
                    ? Colors.green
                    : status == 'Out for delivery'
                        ? Colors.green
                        : status == 'Delivered'
                            ? Colors.green
                            : Colors.grey,
                width: 2,
                height: 100,
              ),
              Row(
                children: [
                  CircleAvatar(
                      backgroundColor: status == 'Out for delivery'
                          ? Colors.green
                          : status == 'Delivered'
                              ? Colors.green
                              : Colors.grey,
                      maxRadius: 10),
                  SizedBox(width: 10),
                  Text(
                    "Out for delivery",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 9),
                color: status == 'Out for delivery'
                    ? Colors.green
                    : status == 'Delivered'
                        ? Colors.green
                        : Colors.grey,
                width: 2,
                height: 100,
              ),
              Row(
                children: [
                  CircleAvatar(
                      backgroundColor:
                          status == 'Delivered' ? Colors.green : Colors.grey,
                      maxRadius: 10),
                  SizedBox(width: 10),
                  Text(
                    "Delivered",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
