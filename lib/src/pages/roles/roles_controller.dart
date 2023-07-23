import 'package:flutter_delivery/src/models/Rol.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class RolesController extends GetxController{

  User user = User.fromJson(GetStorage().read('user') ?? {}); //hacemos el llamado del usuario de sesion

  void goToPageRol(Rol rol) { //metodo para definir las rutas para cada rol de usuario
    Get.offNamedUntil(rol.route ?? '', (route) => false);
  }
}