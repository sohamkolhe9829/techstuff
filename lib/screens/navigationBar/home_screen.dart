import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:provider/provider.dart';
import 'package:techstuff/screens/AppScreens/cart_screen.dart';
import 'package:techstuff/screens/AppScreens/product_detail_screen.dart';
import 'package:techstuff/screens/AppScreens/search_screen.dart';
import 'package:techstuff/widgets/product_card_widget.dart';

import '../../constants/colors.dart';
import '../../providers/order_provider.dart';
import '../../providers/product_provider.dart';
import '../AppScreens/subCat_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _query;
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
    _query = '';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<Container> _carouselItems = [
    Container(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        'assets/img/demo_carousel.png',
        fit: BoxFit.cover,
      ),
    ),
    Container(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        'assets/img/demo_carousel2.png',
        fit: BoxFit.cover,
      ),
    ),
    Container(
      height: double.infinity,
      width: double.infinity,
      child: Image.asset(
        'assets/img/demo_carousel.png',
        fit: BoxFit.cover,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final _orderProvider = Provider.of<OrderProvider>(context, listen: false);
    _orderProvider.getUserData();
    // _reload();
    final _productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    setState(() {
      _productProvider.loadProducts();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlack,
        title: Text(
          "Tech Stuff",
          style: TextStyle(
            color: customWhite,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ));
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ));
            },
            icon: Icon(Icons.shopping_cart_checkout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 485,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('events')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final data = snapshot.data!.docs[index];

                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    child: Image.network(
                                      data.get('imageURL'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                    // carouselSLider(),
                    SizedBox(height: 20),
                    Text(
                      "Top Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    categorySlider(),
                    SizedBox(height: 20),
                    Text(
                      "Top Products",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              SizedBox(
                height: 500,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20),
                  itemCount: _productProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = _productProvider.products[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetailScreen(product: product),
                            ));
                      },
                      child: ProductCardWidget(
                        title: product.name,
                        price: product.price.toString(),
                        rating: product.ratings,
                        imageURL: product.imageURL,
                        discount: product.discount,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  categorySlider() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          catCardWidget(
            context,
            'Laptop',
            'assets/img/catIMG/cat_laptop.jpg',
            SubCatScreen(
              title: 'Laptop',
              category: 'laptop',
            ),
          ),
          catCardWidget(
            context,
            'Desktop',
            'assets/img/catIMG/cat_desktops.jpg',
            SubCatScreen(
              title: 'Desktop',
              category: 'desktop',
            ),
          ),
          catCardWidget(
            context,
            'RAM',
            'assets/img/catIMG/cat_ram.jpg',
            SubCatScreen(
              title: 'RAM',
              category: 'ram',
            ),
          ),
          catCardWidget(
            context,
            'Mouse',
            'assets/img/catIMG/cat_mouse.jpg',
            SubCatScreen(
              title: 'Mouse',
              category: 'mouse',
            ),
          ),
          catCardWidget(
            context,
            'Storage',
            'assets/img/catIMG/cat_ssd.jpg',
            SubCatScreen(
              title: 'Storage',
              category: 'storage',
            ),
          ),
        ],
      ),
    );
  }

  catCardWidget(context, String title, String imgPath, Widget route) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Card(
        elevation: 5,
        child: Container(
          width: MediaQuery.of(context).size.width / 2 - 50,
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(height: 100, child: Image.asset(imgPath)),
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  carouselSLider() {
    return CarouselSlider(
      items: _carouselItems,
      options: CarouselOptions(
        height: 200,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  searchWidget(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        color: customGrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(Icons.search),
            SizedBox(width: 5),
            Text(
              "Search......",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w300),
            ),
          ],
        ),
      ),
    );
  }
}
