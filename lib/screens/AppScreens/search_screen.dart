import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../widgets/search_result.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _query = '';
  String toSentenceCase(String string) {
    if (string == null || string.isEmpty) {
      return '';
    }
    return string.substring(0, 1).toUpperCase() +
        string.substring(1).toLowerCase();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _query = '';
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlack,
        title: TextField(
          style: TextStyle(color: customWhite),
          onChanged: (value) {
            setState(() {
              _query = value;
            });
          },
          decoration: InputDecoration(
            focusColor: customWhite,
            hintText: 'Search products...',
            hintStyle: TextStyle(fontSize: 18, color: customWhite),
          ),
        ),
      ),
      body: _query == ""
          ? Center(
              child: Text(
                "Search for a product......",
                style: TextStyle(fontSize: 22, color: customBlack),
              ),
            )
          : SearchResults(query: toSentenceCase(_query!)),
    );
  }
}
