import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/Rol.dart';
import 'package:get/get.dart';
import 'roles_controller.dart';

class RolesPage  extends StatelessWidget {

  RolesController con = Get.put(RolesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( //aqui llamamos el respectivo appbar de la aplicacion
        title: Text('Seleccionar el rol',
        style:  TextStyle(
          color:Colors.black
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.17),
        child: ListView(
          children: con.user.roles != null ? con.user.roles!.map((Rol rol){ //en esta linea validamos que nos traiga el respectivo rol de usuario o de lo contrario nos traiga un arreglo vacio
            return _cardRol(rol);
        }).toList() : [],
        ),
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector( //widget no visual utilizado principalmente para detectar el gesto del usuario
      onTap: () => con.goToPageRol(rol),
      child: Column(
        children: [
          Container( //imagen del rol correspondiente
            margin: EdgeInsets.only(bottom: 15),
            height: 100,
            child: FadeInImage(
              image: NetworkImage(rol.image!), //imagen correpondiente a cada rol
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 50), //duracion de la animacion de desvanecido de la imagen
              placeholder: AssetImage('assets/img/no-image.png'),
            ),
          ),
          Text(
            rol.name ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          )
        ],
      ),
    );
  }
}
