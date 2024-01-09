import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:techstuff/constants/colors.dart';
import 'package:techstuff/models/order_model.dart';
import 'package:techstuff/models/product_model.dart';
import 'package:techstuff/models/user_model.dart';
import 'package:upi_india/upi_india.dart';

import '../../providers/order_provider.dart';
import '../../widgets/custom_appbar.dart';

enum PaymentOptions { UPI, COD }

class CheckOutScreen extends StatefulWidget {
  CheckOutScreen({super.key, required this.product});

  Product product;

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
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

  PaymentOptions _paymentOption = PaymentOptions.UPI;
  @override
  Widget build(BuildContext context) {
    final _orderProvider = Provider.of<OrderProvider>(context, listen: false);
    _orderProvider.getUserData();

    int orderPrice = (widget.product.price -
            ((widget.product.price / 100) * widget.product.discount).toInt()) +
        (widget.product.price >= 500 ? 40 : 00);

    paymentFunction(double amount) async {
      final UpiIndia upi = UpiIndia();
      UpiResponse result = await upi.startTransaction(
        app: UpiApp.phonePe,
        receiverUpiId: '7470379829@ybl',
        receiverName: 'TechStuff',
        transactionRefId: '50000000',
        transactionNote: 'Pay for techstuff',
        amount: amount,
      );

      print("transaction status is : ${result.status}");
    }

    return Scaffold(
      appBar: CustomAppbar(title: 'Checkout', ctx: context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    headerWidget(context),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                      child: Column(
                        children: [
                          paymentOptionCard(context),
                          SizedBox(height: 15),
                          priceDetailCard(
                              context, widget.product.price, orderPrice),
                          SizedBox(height: 15),
                          Consumer<OrderProvider>(
                            builder: (context, value, child) {
                              return addressCard(
                                  context, _orderProvider.loggedInUser);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                    Text(
                      "₹ $orderPrice",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(width: 15),
                    InkWell(
                      onTap: () {
                        if (_paymentOption == PaymentOptions.UPI) {
                          paymentFunction(double.parse(orderPrice.toString()));
                        } else if (_paymentOption == PaymentOptions.COD) {
                          _orderProvider.orderPrice = orderPrice;
                          if (_paymentOption == PaymentOptions.UPI) {
                            _orderProvider.isPrepaid = true;
                          } else {
                            _orderProvider.isPrepaid = false;
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              int captcha = Random().nextInt(20000) + 15000;
                              TextEditingController _captcha =
                                  TextEditingController();
                              return AlertDialog(
                                title: Text('Confirm order?'),
                                // content:
                                //     Text("Do you want to confirm the order?"),
                                content: SizedBox(
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        captcha.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: Expanded(
                                          child: Center(
                                            child: TextField(
                                              controller: _captcha,
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                label: Text(
                                                    "Enter captcha here.."),
                                                alignLabelWithHint: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              customBlack),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      'Go back',
                                      style: TextStyle(color: customWhite),
                                    ),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              customBlack),
                                    ),
                                    onPressed: () {
                                      if (captcha.toString() == _captcha.text) {
                                        _orderProvider.addToOrder(OrderItem(
                                          productID: widget.product.productID,
                                          product: widget.product,
                                          status: 'Order placed',
                                          orderPrice: widget.product.price + 40,
                                          paymentMethod:
                                              _orderProvider.isPrepaid
                                                  ? 'Prepaid'
                                                  : 'Postpaid',
                                          address: _orderProvider
                                              .loggedInUser.address!,
                                          contact: _orderProvider
                                              .loggedInUser.contact!,
                                          quantity: 1,
                                          userName:
                                              _orderProvider.loggedInUser.name!,
                                          orderID: Random().nextInt(999999),
                                        ));
                                        Fluttertoast.showToast(
                                            msg: 'Order Confirmed ❤');
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/bottomNavBar',
                                            (route) => false);
                                      } else if (_captcha.text == '') {
                                        Fluttertoast.showToast(
                                            msg: 'Enter the captcha..');
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: 'Invalid Captha Code!');
                                      }
                                    },
                                    child: Text(
                                      'Confirm Order',
                                      style: TextStyle(color: customWhite),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        print(_paymentOption);
                      },
                      child: Container(
                        width: 140,
                        height: 40,
                        color: customBlack,
                        child: Center(
                          child: Text(
                            "Continue",
                            style: TextStyle(fontSize: 16, color: customWhite),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  headerWidget(context) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: customWhite,
        boxShadow: [
          BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 30,
                  ),
                  Text(
                    "Order Summary",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Divider(),
              Column(
                children: [
                  Icon(
                    Icons.looks_two_sharp,
                    size: 30,
                  ),
                  Text(
                    "Payment",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  paymentOptionCard(context) {
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
                "Payment Options",
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
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Radio(
                        value: PaymentOptions.UPI,
                        groupValue: _paymentOption,
                        onChanged: (PaymentOptions? value) {
                          setState(() {
                            _paymentOption = value!;
                          });
                        },
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Online Paymment (Prepaid)",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: PaymentOptions.COD,
                        groupValue: _paymentOption,
                        onChanged: (PaymentOptions? value) {
                          setState(() {
                            _paymentOption = value!;
                          });
                        },
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Cash On Delivery (Postpaid)",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  priceDetailCard(context, int price, int orderPrice) {
    var demoPrice = widget.product.price / 100;
    double discountPrice = demoPrice * widget.product.discount;
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
                "Price Details",
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
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Price",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "₹ $price",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discount",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${widget.product.discount}%",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Shipping charges",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "₹ ${price >= 500 ? 40 : 00}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider(thickness: 2, color: Colors.grey[400]),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Amount Payable",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹ $orderPrice",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}
