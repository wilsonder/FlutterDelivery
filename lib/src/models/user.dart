// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'Rol.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {

  String? id; //nos marca error porque estamos usando NULL SAFETY y este nos obliga colocarle valores a las variables
  String? email; //para solucionar los errores hay que colocar ? despues del tipo de dato par indicar que en algun momento llega nulo
  String? name;
  String? lastname;
  String? phone;
  String? image;
  String? password;
  String? sessionToken;
  List<Rol>? roles = [];


  User({
    this.id,
    this.email,
    this.name,
    this.lastname,
    this.phone,
    this.image,
    this.password,
    this.sessionToken,
    this.roles
  });

  //objeto JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    email: json["email"],
    name: json["name"],
    lastname: json["lastname"],
    phone: json["phone"],
    image: json["image"],
    password: json["password"],
    sessionToken: json["session_token"],
    roles: json["roles"] == null ? [] : List<Rol>.from(json["roles"].map((model) => Rol.fromJson(model))), //en esta linea convertimos una lista de tipo JSON a una lista de tipo ROL por medio de un if ternario.

  );

  //metodo para listar los usuarios de la base de datos

  static List<User> fromJsonList(List<dynamic> jsonlist) {
    List<User> toList = [];

    jsonlist.forEach((item) {
      User user = User.fromJson(item);
      toList.add(user);
    });

    return toList;
  }

  //MAPEO DE VALORES

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "name": name,
    "lastname": lastname,
    "phone": phone,
    "image": image,
    "password": password,
    "session_token": sessionToken,
    "roles" : roles
  };
}
