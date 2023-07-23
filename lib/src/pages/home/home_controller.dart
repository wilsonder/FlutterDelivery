import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class HomeController extends GetxController {
  User user = User.fromJson(GetStorage().read('user') ?? {}); //aqui traemos los datos del usuario que inicio sesion

  HomeController() {
    print('USUARIO DE SESION: ${user.toJson()}');
  }

  //metodo para cerrar la sesión del usuario

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false); //eliminar el historial de pantallas..

  }
}