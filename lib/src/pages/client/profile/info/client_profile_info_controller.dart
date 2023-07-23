import 'package:flutter_delivery/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProfileInfoController extends GetxController {

  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;

  void signOut() {
    GetStorage().remove('shopping_bag'); //remover los productos del carrito de compras una vez se cierre la sesion en el dispositivo
    GetStorage().remove('address'); //remover las direcciones una vez se cierre la sesion en el dispositivo
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false); //eliminar el historial de pantallas..

  }

  void goToProfileUpdate() {
    Get.toNamed('/clients/profile/update');
  }

  void GoToRoles() {
    Get.offNamedUntil('/roles', (route) => false);
  }

}