import 'dart:convert';

import 'package:giphysearcher/models/giphy.dart';
import 'package:http/http.dart' as http;
class GiphyApiClient {

  Future<List<Giphy>> getTrendingGiphys() async {
    List<Giphy> giphys = List();
    http.Response response = await http
        .get('https://api.giphy.com/v1/gifs/trending?api_key=0X6eBiPwgy9z1o9PiKpAwG8LtNHhiExW&limit=20&rating=g');
    var jsonDecoded = json.decode(response.body);
    for(var giphy in jsonDecoded['data']) {
      giphys.add(Giphy.fromJson(giphy));
    }
    return giphys;
  }

  Future<List<Giphy>> getGiphysBySearch({String search, int offset}) async {
    List<Giphy> giphys = List();
    http.Response response = await http
        .get('https://api.giphy.com/v1/gifs/search?api_key=0X6eBiPwgy9z1o9PiKpAwG8LtNHhiExW&q=$search&limit=19&offset=$offset&rating=g&lang=en');
    var jsonDecoded = json.decode(response.body);
    for(var giphy in jsonDecoded['data']) {
      giphys.add(Giphy.fromJson(giphy));
    }
    return giphys;
  }
}