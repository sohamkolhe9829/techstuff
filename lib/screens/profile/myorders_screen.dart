import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techstuff/providers/order_provider.dart';
import 'package:techstuff/screens/profile/order_tracking.dart';
import 'package:techstuff/widgets/custom_appbar.dart';

import '../../constants/colors.dart';
import '../../models/user_model.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
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
    final _orderProvider = Provider.of<OrderProvider>(context, listen: false);
    _orderProvider.loadOrderItems();

    setState(() {});
    setState(() {});
    return Scaffold(
      appBar: CustomAppbar(title: 'My Orders', ctx: context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                  child: _orderProvider.orderItems.length == 0
                      ? Center(
                          child: Text(
                            "There is no item in order.....",
                            style: TextStyle(fontSize: 19),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _orderProvider.orderItems.length,
                          itemBuilder: (context, index) {
                            final orderItem = _orderProvider.orderItems[index];
                            return InkWell(
                              onTap: () {
                                setState(() {});
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderTracking(orderItem: orderItem),
                                  ),
                                );
                              },
                              child: MyOrderCard(
                                context,
                                orderItem.product.imageURL,
                                orderItem.product.name,
                                orderItem.orderPrice,
                                orderItem.status,
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  MyOrderCard(
    context,
    String imageURL,
    String title,
    int price,
    String status,
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
                            "$status",
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
