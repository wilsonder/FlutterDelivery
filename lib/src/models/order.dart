import 'dart:convert';

import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/models/user.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {

  String? id;
  String? idClient;
  String? idDelivery;
  String? idAddress;
  String? status;
  double? lat;
  double? lng;
  int? timestamp;
  List<Product>? products = [];
  User? client;
  User? delivery;
  Address? address;

  Order({
     this.id,
     this.idClient,
     this.idDelivery,
     this.idAddress,
     this.status,
     this.lat,
     this.lng,
     this.timestamp,
     this.products,
     this.address,
     this.client,
      this.delivery
  });


  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    idClient: json["id_client"],
    idDelivery: json["id_delivery"],
    idAddress: json["id_address"],
    status: json["status"],
    //if para mostrar una lista de tipo products que se listaron desde el Backend para poder ser mostratdos desde la aplicacion (ver el apartado de notas de Udemy)
    products: json["products"] != null ? List<Product>.from(json["products"].map((model) => model is Product ? model : Product.fromJson(model))) ?? [] : [],
    lat: json["lat"],
    lng: json["lng"],
    timestamp: json["timestamp"],
    //validaciones para poder traer los distintos tipos de listas del Backend.
    client: json['client'] is String ? userFromJson(json['client']) : json['client'] is User ? json['client'] : User.fromJson(json['client'] ?? {}),
    delivery: json['delivery'] is String ? userFromJson(json['delivery']) : json['delivery'] is User ? json['delivery'] : User.fromJson(json['delivery'] ?? {}),
    address: json['address'] is String ? addressFromJson(json['address']) : json['address'] is Address ? json['address'] : Address.fromJson(json['address'] ?? {}),
  );

  //metodo para listar las ordenes de la base de datos

  static List<Order> fromJsonList(List<dynamic> jsonlist) {
    List<Order> toList = [];

    jsonlist.forEach((item) {
      Order order = Order.fromJson(item);
      toList.add(order);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_client": idClient,
    "id_delivery": idDelivery,
    "id_address": idAddress,
    "status": status,
    "lat": lat,
    "lng": lng,
    "timestamp": timestamp,
    "products": products,
    "client": client,
    "delivery": delivery,
    "address": address,
  };
}
