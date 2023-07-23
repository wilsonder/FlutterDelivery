import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/users_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/response_api.dart';

class LoginController extends GetxController { //controlador para el login

  //Captura de datos que el usuario coloque en los campos de usuario y contraseña

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();

  //void significa que es publico
  void GoToRegisterPage() { //este metodo nos llevará a la pantalla del registro una vez se seleccione el texto de Registrate aqui
    Get.toNamed('/register'); // Get.toNamed nos direcciona a la ruta del register la cual esta en el main
  }

  void login() async{
    //evento para el inicio de sesion de los usuarios
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    //imprimir en consola
    print('Email ${email}');
    print('Password ${password}');

    //validacion del login
    if (isValidForm(email, password)) {
      ResponseApi responseApi = await usersProvider.login(email, password);

      print('Response Api: ${responseApi.toJson()}');

      if (responseApi.success == true) {
        GetStorage().write('user', responseApi.data); //DATOS DEL USUARIO EN SESION
        User myUser = User.fromJson(GetStorage().read('user')  ?? {}); //AQUI TRAEMOS EL RESPECTIVO USUARIO PARA HACER LAS VALIDACIONES
        if (myUser.roles!.length >1) { //EN ESTA LINEA VALIDAMOS AL MOMENTO DE INICIAR SESION SI EL USUARIO TIENE MAS DE 1 ROL SI ES ASI LO MANDAMOS A LA PANTALLA DE ROLES
          goToRolesPage();
        }else {
          goToClientHomePage(); // DE LO CONTRARIO SE ENVIA A LA LISTA DE PRODUCTOS DISPONIBLES YA QUE ES UN CLIENTE
        }

      }else{
        Get.snackbar('Login Fallido', responseApi.message ?? '');
      }
    }
  }

  void goToClientHomePage() {
    Get.offNamedUntil('/clients/home', (route) => false);
  }

  void goToRolesPage() {
    Get.offNamedUntil('/roles', (route) => false); //offNamedUntil elimina todo el historial de pantallas
  }


  bool isValidForm(String email, String password) {

      if(email.isEmpty) {
        Get.snackbar('Formulario no válido', 'Debes ingresar el email'); // snackbar: mensajes para mostrar en pantalla similar al Toast de java
        return false;
      }

      if (!GetUtils.isEmail(email)) {
        Get.snackbar('Formulario no válido', 'El emaill no es valido');
        return false;
      }

      if(password.isEmpty) {
        Get.snackbar('Formulario no válido', 'Debes ingresar el password'); // snackbar: mensajes para mostrar en pantalla similar al Toast de java
        return false;
      }

      return true;
    }



}