import 'package:flutter/material.dart';

import '../constants/colors.dart';

class HomeProductCard extends StatelessWidget {
  String imageURL;
  String name;
  double price;

  HomeProductCard({
    required this.imageURL,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: 155,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: customWhite,
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            width: 120,
            child: Image.asset(
              '$imageURL',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: 75,
            width: 120,
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                children: [
                  Text(
                    "$name",
                    style: TextStyle(fontSize: 13),
                  ),
                  Row(
                    children: [
                      Text(
                        "₹ $price",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 20),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add_shopping_cart,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
