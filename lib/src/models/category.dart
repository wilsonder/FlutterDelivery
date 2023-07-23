import 'dart:convert';

import 'package:flutter/foundation.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {

  String? id;
  String? name;
  String? description;


  Category({
    this.id,
     this.name,
     this.description,
  });


  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    description: json["description"],
  );

  //metodo para listar las categorias de la base de datos

  static List<Category> fromJsonList(List<dynamic> jsonlist) {
    List<Category> toList = [];

    jsonlist.forEach((item) {
      Category category = Category.fromJson(item);
      toList.add(category);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
  };
}
