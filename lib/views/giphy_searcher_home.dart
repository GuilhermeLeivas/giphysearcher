import 'package:flutter/material.dart';
import 'package:giphysearcher/giphy_api/giphy_api_client.dart';
import 'package:giphysearcher/models/giphy.dart';
import 'package:giphysearcher/views/giphy_page.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class GiphySearcherHome extends StatefulWidget {
  @override
  _GiphySearcherHomeState createState() => _GiphySearcherHomeState();
}

class _GiphySearcherHomeState extends State<GiphySearcherHome> {
  TextEditingController _searchController = TextEditingController();
  GiphyApiClient apiClient = GiphyApiClient();
  bool isSearch = false;
  int offset = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.network(
              "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    labelText: 'Pesquisar',
                    labelStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Pesquise por giphys irados',
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                    ),
                    border: OutlineInputBorder()),
                onChanged: (value) async {
                  if(value.length > 0) {
                    setState(() {
                      isSearch = true;
                      offset = 0;
                      giphysFetchHandle();
                    });
                  } else {
                    setState(() {
                      isSearch = false;
                    });
                  }
                },
              ),
            ),
            Divider(),
            Expanded(
              child: giphysFetchHandle(),
            )
          ],
        ));
  }

  Widget giphysFetchHandle() {
    return FutureBuilder(
      future: isSearch ? _getGiphysBySearch() : _getTrendingGiphys(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Text(
                  'Problemas ao carregar dados',
                  style: TextStyle(fontSize: 24.0),
                ),
              );
            } else {
              return giphysGrid(context, snapshot.data);
            }
            break;
        }
        return Container();
      },
    );
  }

  Widget giphysGrid(BuildContext context, List<Giphy> giphys) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Quantidade de itens por linha
        crossAxisSpacing: 8.0, // Espaco entre itens na horizontal
        mainAxisSpacing: 8.0, // Espaco entre itens na vertical
      ),
      itemCount: isSearch ? giphys.length+1 : giphys.length,
      itemBuilder: (context, index) {
        if(index == giphys.length) {
          return Container (
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 32.0,),
                  Text('Carregar mais', style: TextStyle(fontSize: 16.0),),
                ],
              ),
              onTap: () {
                setState(() {
                  offset += 19;
                });
              },
            ),
          );
        } else {
        return GestureDetector(
          // Foi usado o GestureDetector para podermos clicar nos Gifs
          child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: giphys[index].imageUrl,
              height: 300.0,
            fit: BoxFit.fitHeight,
          ),
          onLongPress: () {
            Share.share(giphys[index].imageUrl, subject: giphys[index].title);
          },
          onTap: () => _showGiphyDialog(giphys[index]),
        );
        }
      },
    );
  }
  _showGiphyDialog(Giphy giphy) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text('Title: ' + giphy.title),
          content: Image.network(giphy.imageUrl),
          actions: <Widget>[
            FlatButton(
              child: Text('Close me!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ));
  }

  _getTrendingGiphys() async {
    List<Giphy> giphys = await apiClient.getTrendingGiphys();
    return giphys;
  }
  _getGiphysBySearch() async {
    List<Giphy> giphys = await apiClient.getGiphysBySearch(search: _searchController.text, offset: offset);
    return giphys;
  }
}
