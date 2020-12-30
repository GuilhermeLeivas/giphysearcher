//import 'package:json_annotation/json_annotation.dart';

// executar no terminal:flutter pub run build_runner build
//part 'giphy.g.dart';

//@JsonSerializable()
class Giphy {
  final String title;
  final String imageUrl;

  Giphy({this.title, this.imageUrl});

  factory Giphy.fromJson(Map<String, dynamic> json) {
    return Giphy(
      title: json['title'],
      imageUrl: json['images']['fixed_height']['url']
    );
  }

}
