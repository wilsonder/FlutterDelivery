import 'dart:convert';
import 'dart:io';

import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ProductsProvider extends GetConnect {

  User userSession = User.fromJson(GetStorage().read('user') ?? {});

  String url = Environment.API_URL + 'api/products';


 //metodo para llamar los productos pertenecientes a cada categoria
  Future<List<Product>> findByCategory(String idCategory) async {
    //async nos permite realizar peticiones HTTP
    Response response = await get( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/findByCategory/$idCategory',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta infromacion');
      return [];
    }

    List<Product> products = Product.fromJsonList(response.body);

    return products;
  }

  //metodo para llamar los productos por nombre
  Future<List<Product>> findByNameAndCategory(String idCategory,String name) async {
    //async nos permite realizar peticiones HTTP
    Response response = await get( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/findByNameAndCategory/$idCategory/$name',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido leer esta infromacion');
      return [];
    }

    List<Product> products = Product.fromJsonList(response.body);

    return products;
  }


  Future<Stream> create(Product product, List<File> images) async {
      Uri uri = Uri.http(Environment.API_URL_OLD,
          '/api/products/create'); //ruta para registro con imagenes de node js
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = userSession.sessionToken ?? '';

      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            //cantidad de caracteres con los cuales se nombra una imagen
            filename: basename(images[i].path)
        ));
      }

      request.fields['product'] =
          json.encode(product); // aqui se llama el usuario el cual se registro
      final response = await request.send();
      return response.stream.transform(utf8.decoder);
    }
  }


