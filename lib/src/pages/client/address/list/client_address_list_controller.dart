import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/address_provider.dart';
import 'package:flutter_delivery/src/providers/orders_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientAdressListController extends GetxController {

  List<Address> address = [];
  AddressProvider addresProvider = AddressProvider();
  User user = User.fromJson(GetStorage().read ('user') ?? {});

  OrdersProvider ordersProvider = OrdersProvider();

  var radioValue = 0.obs;

  ClientAdressListController() {
    print('LA DIRECCION DER SESION ${GetStorage().read('address')}');
  }

  //metodo para obtener las direcciones por usuario.
  Future<List<Address>> getAddress() async {
    address = await addresProvider.findByUser(user.id ?? '');

    Address a = Address.fromJson(GetStorage().read('address') ?? {}); //DIRECCION SELECCIONADA POR EL USUARIO (ALMACENADA EN SESION);
    int index = address.indexWhere((ad) => ad.id == a.id);

    if (index != -1) { // la direccion coincide con un dato de la lista de dirreciones
      radioValue.value = index;

    }

    return address;
  }

  void createOrder() async{


    Get.toNamed('/clients/payments/create');

  }

  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    print('VALOR SELECCIONADO ${value}');
    GetStorage().write('address', address[value].toJson()); //guardar la direccion seleccionada por el usuario en storage.
    update();
  }



  void goToAdressCreate() {
    Get.toNamed('/clients/address/create');
  }

}