import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery/src/models/address.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:flutter_delivery/src/pages/client/address/map/client_address_map_page.dart';
import 'package:flutter_delivery/src/providers/address_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientAdressCreateController extends GetxController {

  TextEditingController addressController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController refPointController = TextEditingController();

  double latRefPoint = 0;
  double lngRefPoint = 0;

  User user = User.fromJson(GetStorage().read('user') ?? {});
  AddressProvider addresProvider = AddressProvider();

  ClientAdressListController clientAddressListController = Get.find();

  //metodo para abrir le mapa de google
  void openGoogleMaps(BuildContext context) async{
    Map<String, dynamic> refPointMap = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientAdressMapPage(),
        isDismissible: false,
      enableDrag: false

    );


    //punto de reeferencia para guardar la direccion seleccionada en el mapa
    refPointController.text = refPointMap['address'];
    latRefPoint = refPointMap['lat'];
    lngRefPoint = refPointMap['lng'];
    print('REF PONT MAP ${refPointMap}');

  }

  void createAddress() async {
    String addressName = addressController.text;
    String neighborhood = neighborhoodController.text;

    if (isValidForm(addressName, neighborhood)) {
      Address address = Address(
        address: addressName,
        neighborhood: neighborhood,
        lat: lngRefPoint,
        lng: lngRefPoint,
        idUser: user.id
      );

      ResponseApi responseApi = await addresProvider.create(address);
      Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);

      if (responseApi.success == true) {
        address.id  = responseApi.data;
        GetStorage().write('address', address.toJson());

        clientAddressListController.update(); //actualizar la pagina para que al seleccionar un punto del mapa automaticamente se muestre en la pantalla de mis direcciones
        Get.back();
      }



    }

  }

  bool isValidForm(String address, String neighborhood) {
    if(address.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el nombre de la direccion');
      return false;
    }
    if(neighborhood.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el nombre del barrio');
      return false;
    }
    if(latRefPoint == 0) {
      Get.snackbar('Formulario no válido', 'Selecciona el punto de referencia');
      return false;
    }
    if(lngRefPoint == 0) {
      Get.snackbar('Formulario no válido', 'Selecciona el punto de referencia');
      return false;
    }
    return true;

  }

}