import 'package:flutter/material.dart';

import 'views/giphy_searcher_home.dart';

void main() {
  runApp(GiphySearcherApp());
}

class GiphySearcherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: GiphySearcherHome(),
    );
  }
}

