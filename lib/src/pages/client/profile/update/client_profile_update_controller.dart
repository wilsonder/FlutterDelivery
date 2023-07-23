import 'dart:convert';
import 'dart:io';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:flutter_delivery/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ClientProfieUpdateController extends GetxController {

  User user = User.fromJson(GetStorage().read('user'));

  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  UsersProvider usersProvider = UsersProvider();
  ClientProfileInfoController  clientProfileInfoController = Get.find();

  ClientProfieUpdateController() {
    nameController.text = user.name ?? '';
    lastnameController.text = user.lastname ?? '';
    phoneController.text = user.phone ?? '';
  }

  //metodo Future para seleccionar una imagen bien sea por camara o por galeria
  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }

  }

  void updateInfo(BuildContext context) async {
    //evento para el registro de los usuarios

    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;



    if (isValidForm(name,lastname,phone)) {

      ProgressDialog progressDialog =  ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Actualizando Datos...');

      User myUser = User(
        id: user.id,
        name: name,
        lastname: lastname,
        phone: phone,
        sessionToken: user.sessionToken
      );

      //PROCESO DE ACTUALIZACION DE DATOS

      // si el usuario no selecciona una nueva imagen entonces aqui se actualiza la nueva informacion
      if (imageFile == null) {
        ResponseApi responseApi = await usersProvider.update(myUser);
        print('Response Api Update: ${responseApi.data}');
        Get.snackbar('Proceso terminado', responseApi.message ?? '');
        progressDialog.close();
        if (responseApi.success == true) {  // si el proceso es exitoso a continuacion se asigna la nueva informacion que el usuario ingreso
          GetStorage().write('user', responseApi.data); //GetStorage almacenamos la nueva informacion del usuario despues de ser actualizada
          clientProfileInfoController.user.value = User.fromJson(responseApi.data);
        }
      }else {

        //Realizar el llmadao para actualizar la  imagen

        Stream stream = await usersProvider.updateWithImage(myUser, imageFile!);
        stream.listen((res) {

          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          Get.snackbar('Proceso terminado', responseApi.message ?? '');
          print('Response Api Update: ${responseApi.data}');
          progressDialog.close();
          if (responseApi.success ==  true ) {

            GetStorage().write('user', responseApi.data);
            clientProfileInfoController.user.value = User.fromJson(responseApi.data);

          }else {
            Get.snackbar('Registro  Fallido', responseApi.message ?? '');
          }

        });

      }



    }
  }

  bool isValidForm(String name, String lastname, String phone) {

    if (name.isEmpty) {
      Get.snackbar('Registro Inválido', 'Debes ingresar el Nombre');
      return false;
    }

    if (lastname.isEmpty) {
      Get.snackbar('Registro Inválido', 'Debes ingresar el Apellido');
      return false;
    }

    if(phone.isEmpty) {
      Get.snackbar('Registro Invalido', 'Debes ingresar el Télefono');
      return false;
    }

    return true;
  }

  //metodo para seleccionar foto de la galeria o la camara en el registro de usuarios

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back(); //linea para que se cierre el alertDailog al seleccionar una opcion
          selectImage(ImageSource.gallery);  //llmar a a la galeria por medio de la libreria image_picker

        },
        child: Text('GALERIA',
          style: TextStyle(
              color:Colors.black
          ),
        )
    );
    Widget cameraButton = ElevatedButton(
        onPressed: () {
          Get.back(); //linea para que se cierre el alertDailog al seleccionar una opcion
          selectImage(ImageSource.camera);  //llmar a a la camara por medio de la libreria image_picker
        },
        child: Text('CAMARA',
          style: TextStyle(
              color: Colors.black
          ),
        )
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text('Selecciona una opcion'),
      actions: [
        galleryButton,
        cameraButton
      ],
    );

    showDialog(context: context, builder: (BuildContext) {

      return alertDialog;

    });

  }

}