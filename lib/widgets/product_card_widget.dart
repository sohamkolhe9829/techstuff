import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ProductCardWidget extends StatelessWidget {
  String imageURL;
  String title;
  String price;
  int rating;
  int discount;

  ProductCardWidget({
    required this.title,
    required this.price,
    required this.rating,
    required this.imageURL,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    var demoPrice = int.parse(price) / 100;
    var discountPrice = demoPrice * discount;
    return Container(
      clipBehavior: Clip.hardEdge,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: customWhite,
      ),
      child: Column(
        children: [
          Container(
            height: 120,
            width: 180,
            child: Image.network(
              imageURL,
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            height: 75,
            width: 180,
            color: Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: SizedBox(
                      height: 20,
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "$price ",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.lineThrough),
                          ),
                          TextSpan(
                            text:
                                '₹ ${int.parse(price) - discountPrice.toInt()} ',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: customBlack),
                          ),
                          TextSpan(
                            text: '$discount% off',
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.green,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                      ),
                    ),
                    // child: Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Text(
                    //       "$price ",
                    //       style: TextStyle(
                    //           fontSize: 15,
                    //           color: Colors.grey[600],
                    //           fontWeight: FontWeight.bold,
                    //           decoration: TextDecoration.lineThrough),
                    //     ),
                    //     Text(
                    //       "₹ ${int.parse(price) - discountPrice.toInt()} ",
                    //       style: TextStyle(
                    //           fontSize: 16, fontWeight: FontWeight.bold),
                    //     ),
                    //     Text(
                    //       '$discount% off',
                    // style: TextStyle(
                    //     color: Colors.green,
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold),
                    // ),
                    //   ],
                    // ),
                  ),
                  Row(
                    children: [
                      rating >= 1 ? Icon(Icons.star) : Icon(Icons.star_border),
                      rating >= 2 ? Icon(Icons.star) : Icon(Icons.star_border),
                      rating >= 3 ? Icon(Icons.star) : Icon(Icons.star_border),
                      rating >= 4 ? Icon(Icons.star) : Icon(Icons.star_border),
                      rating == 5 ? Icon(Icons.star) : Icon(Icons.star_border),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
