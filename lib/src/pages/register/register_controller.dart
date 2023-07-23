import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';



class RegisterController extends GetxController {

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile;

  void register(BuildContext context) async {
    //evento para el registro de los usuarios
    String email = emailController.text.trim(); //.trim() elimina los espacios en blanco
    String name = nameController.text;
    String lastname = lastnameController.text;
    String phone = phoneController.text;
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    //imprimir en consola
    print('Email ${email}');
    print('Password ${password}');

    if (isValidForm(email,name,lastname,phone,password,confirmPassword)) {

      ProgressDialog progressDialog =  ProgressDialog(context: context);
      progressDialog.show(max: 100, msg: 'Registrando Datos...');

      User user = User(
        email: email,
        name: name,
        lastname: lastname,
        phone: phone,
        password: password,
      );

      //Realizar el llmadao de la imagen

      Stream stream = await usersProvider.createWithImage(user, imageFile!);
      stream.listen((res) {
        progressDialog.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

        if (responseApi.success == true ) {
          GetStorage().write('user', responseApi.data); //DATOS DEL USUARIO EN SESION
          goToHomePage();

        }else {
          Get.snackbar('Registro  Fallido', responseApi.message ?? '');
        }

      });

    }
  }

  void goToHomePage() {
    Get.offNamedUntil('/client/products/list', (route) => false);
  }

  bool isValidForm(String email,String name, String lastname, String phone, String password, String confirmPassword) {

    if(email.isEmpty) {
      Get.snackbar('Formulario no válido', 'Debes ingresar el email'); // snackbar: mensajes para mostrar en pantalla similar al Toast de java
      return false;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Formulario no válido', 'El emaill no es valido');
      return false;
    }

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


    if(password.isEmpty) {
      Get.snackbar('Formulario no válido', 'Debes ingresar el password'); // snackbar: mensajes para mostrar en pantalla similar al Toast de java
      return false;
    }

    if (confirmPassword.isEmpty) {
      Get.snackbar('Registro Invalido', 'Debes confirmar la contraseña');
      return false;
    }

    if (password != confirmPassword) {
      Get.snackbar('Registro Invalido', 'Las contraseñas no coinciden');
      return false;
    }
    
    if (imageFile == null) {
      Get.snackbar('Formulario no valido ', 'Debes seleccionar una imagen de perfil');
      return false;
    }

    return true;
  }

  //metodo Future para seleccionar una imagen bien sea por camara o por galeria
  Future selectImage(ImageSource imageSource) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      imageFile = File(image.path);
      update();
    }

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
          color:Colors.white
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
          color: Colors.white
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
