import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GiphyPage extends StatelessWidget {
  final String giphyUrl;
  final String title;
  GiphyPage({this.giphyUrl, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seu Giphy'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              Share.share(giphyUrl, subject: title);
            },
          ),
        ],
      ),
      body: _giphyWidget(),
    );
  }
  Widget _giphyWidget() {
    return Center(
      child: Container(
        height: 300,
        width: 300,
        child: Image.network(giphyUrl),
      ),
    );
  }
}
