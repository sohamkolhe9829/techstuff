import 'package:flutter/material.dart';
import 'package:techstuff/screens/AppScreens/subCat_screen.dart';

import '../../constants/colors.dart';

class Categorycreen extends StatelessWidget {
  const Categorycreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlack,
        title: Text(
          "Category",
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
          child: GridView.count(
            crossAxisCount: 2,
            children: [
              catCardWidget(
                context,
                "Keyboard",
                "assets/img/catIMG/cat_keyboard.jpg",
                SubCatScreen(
                  title: 'Keyboard',
                  category: 'keyboard',
                ),
              ),
              catCardWidget(
                context,
                "Mouse",
                "assets/img/catIMG/cat_mouse.jpg",
                SubCatScreen(
                  title: 'Mouse',
                  category: 'mouse',
                ),
              ),
              catCardWidget(
                context,
                "Laptop",
                "assets/img/catIMG/cat_laptop.jpg",
                SubCatScreen(
                  title: 'Laptop',
                  category: 'laptop',
                ),
              ),
              catCardWidget(
                context,
                "Desktop",
                "assets/img/catIMG/cat_desktops.jpg",
                SubCatScreen(
                  title: 'Desktop',
                  category: 'desktop',
                ),
              ),
              catCardWidget(
                context,
                "Monitor",
                "assets/img/catIMG/cat_monitors.jpeg",
                SubCatScreen(
                  title: 'Monitor',
                  category: 'monitor',
                ),
              ),
              catCardWidget(
                context,
                "Cabinate",
                "assets/img/catIMG/cat_cabinates.jpg",
                SubCatScreen(
                  title: 'Cabinate',
                  category: 'cabinate',
                ),
              ),
              catCardWidget(
                context,
                "Motherboard",
                "assets/img/catIMG/cat_motherboards.jpg",
                SubCatScreen(
                  title: 'Motherboard',
                  category: 'motherboard',
                ),
              ),
              catCardWidget(
                context,
                "RAM",
                "assets/img/catIMG/cat_ram.jpg",
                SubCatScreen(
                  title: 'RAM',
                  category: 'RAM',
                ),
              ),
              catCardWidget(
                context,
                "Storage",
                "assets/img/catIMG/cat_ssd.jpg",
                SubCatScreen(
                  title: 'Storage',
                  category: 'storage',
                ),
              ),
              catCardWidget(
                context,
                "UPS",
                "assets/img/catIMG/cat_ups.jpg",
                SubCatScreen(
                  title: 'UPS',
                  category: 'ups',
                ),
              ),
              catCardWidget(
                context,
                "Cables",
                "assets/img/catIMG/cat_cables.jpg",
                SubCatScreen(
                  title: 'Cables',
                  category: 'cable',
                ),
              ),
              catCardWidget(
                context,
                "Connectors",
                "assets/img/catIMG/cat_connectors.jpg",
                SubCatScreen(
                  title: 'Connectors',
                  category: 'connector',
                ),
              ),
              catCardWidget(
                context,
                "Power Supply",
                "assets/img/catIMG/cat_psu.jpg",
                SubCatScreen(
                  title: 'Power Supply',
                  category: 'PSU',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  catCardWidget(context, String title, String imgPath, Widget route) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => route));
      },
      child: Card(
        elevation: 15,
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(height: 130, child: Image.asset(imgPath)),
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
}
