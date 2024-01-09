import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  BuildContext ctx;

  CustomAppbar({Key? key, required this.title, required this.ctx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(ctx).pop();
        },
        icon: Icon(
          Icons.arrow_back_ios,
        ),
      ),
      backgroundColor: customBlack,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: customWhite,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
