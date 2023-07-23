import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get_storage/get_storage.dart';

class OrdersProvider extends GetConnect {

  // en esta linea apuntamos a las rutas de las categorias que configuramos en node js
  String url = Environment.API_URL + 'api/orders';

  User userSession = User.fromJson(GetStorage().read('user') ?? {}); // llamado del usuario de sesion

  // metodo para listar las ordenes (obtener listas de datos de tipo json)

  Future<List<Order>> findByStatus(String status) async { //async nos permite realizar peticiones HTTP
    Response response = await get( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/findByStatus/$status',
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if(response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta infromacion');
      return [];
    }

    List<Order> orders = Order.fromJsonList(response.body);

    return orders;
  }

  Future<List<Order>> findByDeliveryAndStatus(String idDelivery, String status) async { //async nos permite realizar peticiones HTTP
    Response response = await get( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/findByDeliveryAndStatus/$idDelivery/$status',
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if(response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta infromacion');
      return [];
    }

    List<Order> orders = Order.fromJsonList(response.body);

    return orders;
  }

  Future<List<Order>> findByClientAndStatus(String idClient, String status) async { //async nos permite realizar peticiones HTTP
    Response response = await get( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/findByClientAndStatus/$idClient/$status',
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    if(response.statusCode == 401) {
      Get.snackbar('Peticion denegada', 'Tu usuario no tiene permitido leer esta infromacion');
      return [];
    }

    List<Order> orders = Order.fromJsonList(response.body);

    return orders;
  }


  //metodo para apuntar a la ruta de registro de categorias que se definió en node js en el archivo userRoutes
  Future<ResponseApi> create(Order order) async { //async nos permite realizar peticiones HTTP
    Response response = await post( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/create',
        order.toJson(),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }


  //cambiiar de estado la orden de pagado a despachado
  Future<ResponseApi> updateToDispatched(Order order) async { //async nos permite realizar peticiones HTTP
    Response response = await put( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/updateToDispatched',
        order.toJson(),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  //cambiar de estado la orden de pagado a en camino
  Future<ResponseApi> updateToOnTheWay(Order order) async { //async nos permite realizar peticiones HTTP
    Response response = await put( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/updateToOnTheWay',
        order.toJson(),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  //cambiar de estado la orden de EN CAMINO A PAGADO
  Future<ResponseApi> updateToDelivered(Order order) async { //async nos permite realizar peticiones HTTP
    Response response = await put( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/updateToDelivered',
        order.toJson(),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }

  //guardar la laatitud y la longitud de la posicion del usuario.

  Future<ResponseApi> updateLatLng(Order order) async { //async nos permite realizar peticiones HTTP
    Response response = await put( //await ejecuta la linea Response y espera hasta que el post se realice
        '$url/updateLatLng',
        order.toJson(),
        headers: {
          'Content-Type' : 'application/json',
          'Authorization': userSession.sessionToken ?? ''
        }
    ); // Esperar hasta que el servidor nos retorne una respuesta

    ResponseApi responseApi = ResponseApi.fromJson(response.body);

    return responseApi;
  }


}