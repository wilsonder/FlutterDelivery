import 'dart:convert';
import 'dart:io';

import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';
import '../models/response_api.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart'; //este paquete nos permite trabajar con peticiones GET de manera sencilla

class UsersProvider extends GetConnect {

  // en esta linea apuntamos a las rutas del  usuario que configuramos en node js
  String url = Environment.API_URL + 'api/users';

  User userSession = User.fromJson(GetStorage().read('user') ?? {}); // llamado del usuario de sesion

  // metodo para listar los usuarios con el rol repartidor
  Future<List<User>> findDeliveryMen() async { //async nos permite realizar peticiones HTTP
    Response response = await get( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/findDeliveryMen',
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if(response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta infromacion');
      return [];
    }

    List<User> users = User.fromJsonList(response.body);

    return users;
  }


  //metodo para apuntar a la ruta de registro de usuarios que se definió en node js en el archivo userRoutes
  Future<Response> create(User user) async { //async nos permite realizar peticiones HTTP
    Response response = await post( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/create',
        user.toJson(),
        headers: {
          'Content-Type' : 'application/json'
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    return response;
  }

  //metodo para actualizar los datos del usuario SIN imagen

  Future<ResponseApi> update(User user) async { //async nos permite realizar peticiones HTTP
    Response response = await put( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/updateWithoutImage',
        user.toJson(),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo actualizar la información');
      return ResponseApi();
    }

    // si el backend no nos genera error 401 es porque no esta autorizado para realizar la peticion de actualizacion de datos por ello hacemos esta validacion para que NO quede en un cliclo infinito
    // validacion para la adicion de autorizacion JWT en el userRoutes del backend en node js
    if (response.statusCode  == 401) {
      Get.snackbar('Error', 'No estas autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  /*metodo para almacenar imagenes sin importar el tamaño que tengan con el metodo HTTP */

  Future<Stream> createWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/createWithImage'); //ruta para registro con imagenes de node js
    final request = http.MultipartRequest('POST', uri);
    request.files.add(http.MultipartFile(
      'image',
      http.ByteStream(image.openRead().cast()),
      await image.length(), //cantidad de caracteres con los cuales se nombra una imagen
      filename: basename(image.path)
    ));
    request.fields['user'] = json.encode(user); // aqui se llama el usuario el cual se registro
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  /*metodo para actualizar los datos del usuario con la imagen*/

  Future<Stream> updateWithImage(User user, File image) async {
    Uri uri = Uri.http(Environment.API_URL_OLD, '/api/users/update'); //ruta para registro con imagenes de node js
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = userSession.sessionToken ?? '';
    request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(), //cantidad de caracteres con los cuales se nombra una imagen
        filename: basename(image.path)
    ));
    request.fields['user'] = json.encode(user); // aqui se llama el usuario el cual se registro
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }



  //metodo para registrar  el usuario con imaaen de perfil con el paquete GET X

  /*Future<ResponseApi> createUserWithImageGetX(User user, File image) async {
    FormData form = FormData({
      'image': MultipartFile(image, filename: basename(image.path)),
      'user' : json.encode(user)
    });
    Response response = await post('$url/create', form);

    if (response.body == null) {
      Get.snackbar('Error en la petición', 'No se pudo crear el usuario');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }*/

  //metodo para apuntar a la ruta de registro de usuarios que se definió en node js en el archivo userRoutes
  Future<ResponseApi> login(String email, String password) async { //async nos permite realizar peticiones HTTP
    Response response = await post( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/login',
        {
          'email': email,
          'password': password
        },
        headers: {
          'Content-Type' : 'application/json'
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if (response.body == null) {
      Get.snackbar('Error', 'NO se pudo ejecutar la peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  Future<ResponseApi> updateNotificationToken(String id, String token) async { //async nos permite realizar peticiones HTTP
    Response response = await put( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/updateNotificationToken',
        {
          'id': id,
          'token' : token
        },
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo actualizar la información');
      return ResponseApi();
    }

    // si el backend no nos genera error 401 es porque no esta autorizado para realizar la peticion de actualizacion de datos por ello hacemos esta validacion para que NO quede en un cliclo infinito
    // validacion para la adicion de autorizacion JWT en el userRoutes del backend en node js
    if (response.statusCode  == 401) {
      Get.snackbar('Error', 'No estas autorizado para realizar esta peticion');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

}