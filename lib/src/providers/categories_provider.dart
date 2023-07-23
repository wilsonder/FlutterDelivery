

import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';

class CategoriesProvider extends GetConnect {

  // en esta linea apuntamos a las rutas de las categorias que configuramos en node js
  String url = Environment.API_URL + 'api/categories';

  User userSession = User.fromJson(GetStorage().read('user') ?? {}); // llamado del usuario de sesion

  // metodo para listar las categorias (obtener listas de datos de tipo json)

  Future<List<Category>> getAll() async { //async nos permite realizar peticiones HTTP
    Response response = await get( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/getAll',
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if(response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta infromacion');
      return [];
    }

    List<Category> categories = Category.fromJsonList(response.body);

    return categories;
  }


  //metodo para apuntar a la ruta de registro de categorias que se definió en node js en el archivo userRoutes
  Future<ResponseApi> create(Category category) async { //async nos permite realizar peticiones HTTP
    Response response = await post( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/create',
        category.toJson(),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

}