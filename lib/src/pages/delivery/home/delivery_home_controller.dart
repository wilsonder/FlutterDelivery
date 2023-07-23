import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/push_notifications_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DeliveryHomeController extends GetxController {

  //var helloWorld = 'Hola Mundo'.obs; //EN FLUTTER LAS VARIABLES QUE CAMBIAN DE VALOR SE DECLARAN COMO VAR Y el obs significa observable

 // void  changeVar() {
 //   helloWorld.value = 'Good Bye'; // value asigna nuevos valores a las variables.
 // }

  PushNotificationsProvider pushNotificationProvider = PushNotificationsProvider();
  User user = User.fromJson(GetStorage().read('user'));

  var indexTab = 0.obs; // variable para saber en que seccion del bottom bar nos encontramos.

  void changeTab(int index) {
    indexTab.value = index;  // asigar nuevo valor al indexTab y reasignarlo a index
  }

  DeliveryHomeController() {
    saveToken();
  }

  void saveToken() {
    if(user.id != null) {
      pushNotificationProvider.saveToken(user.id!);
    }
  }

  void signOut() {
    GetStorage().remove('user');
    Get.offNamedUntil('/', (route) => false); //eliminar el historial de pantallas..

  }

}