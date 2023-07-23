

import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';

class AddressProvider extends GetConnect {

  // en esta linea apuntamos a las rutas de las categorias que configuramos en node js
  String url = Environment.API_URL + 'api/address';

  User userSession = User.fromJson(GetStorage().read('user') ?? {}); // llamado del usuario de sesion

  // metodo para listar las direcciones (obtener listas de datos de tipo json)

  Future<List<Address>> findByUser(String idUser) async { //async nos permite realizar peticiones HTTP
    Response response = await get( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/findByUser/$idUser',
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if(response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta infromacion');
      return [];
    }

    List<Address> address = Address.fromJsonList(response.body);

    return address;
  }


  //metodo para apuntar a la ruta de registro de categorias que se definió en node js en el archivo userRoutes
  Future<ResponseApi> create(Address address) async { //async nos permite realizar peticiones HTTP
    Response response = await post( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/create',
        address.toJson(),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

}