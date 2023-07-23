import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/profile/info/client_profile_info_controller.dart';
import 'package:get/get.dart';

class ClientProfileInfoPage extends StatelessWidget {

  ClientProfileInfoController con = Get.put(ClientProfileInfoController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(()=>Stack(  //Stack sirve para posicionar elementos uno encima del otro
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _imageUser(context),
            Column(
              children: [
                _buttonSignOut(),
                _buttonGoToRoles()
              ],
            ),


          ],
        )),
    );
  }

  Widget _buttonSignOut() {
    return SafeArea(
        child: Container(
          margin: EdgeInsets.only(right: 20),
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => con.signOut(),
            icon: Icon(Icons.power_settings_new,
              color: Colors.white,
              size: 30,
            ),
          ),
        )
    );
  }

  Widget _buttonGoToRoles() {
    return Container(
      margin: EdgeInsets.only(right: 20),
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => con.GoToRoles(),
        icon: Icon(Icons.supervised_user_circle,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }




  //Fragmento amarillo del widget
  Widget _backgroundCover(BuildContext context) { //BuildContext parametro para trabajar con porcentajes o resolucion de pantalla
    return Container(
      width: double.infinity, //double.infinity indica que va a ocupar todo el ancho  de la pantala
      height: MediaQuery.of(context).size.height * 0.35, // este metodo agranda el container amarillo y a su vez lo hace responsive adaptandolo a cualquier tipo de pantalla
      color: Colors.amber, // Colors establece el color amarillo para el backgrund

    );
  }

  Widget _boxForm(BuildContext context) {  //BuildContext parametro para trabajar con porcentajes o resolucion de pantalla
    return Container(
      height: MediaQuery.of(context).size.height * 0.4, // este metodo agranda el container amarillo y a su vez lo hace responsive adaptandolo a cuaalquier tipo de pantalla
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3, left: 50, right: 50),
      decoration: BoxDecoration( // en esta parte de configura el estilo del container como sombras,altura,color, etc.
          color: Colors.white,
          boxShadow: <BoxShadow> [
            BoxShadow( //aqui se establece las propiedades para las sombras del container que tiene el inicio de sesion
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 0.75)
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textName(),
            _textEmail(),
            _textPhone(),
            _buttonUpdate(context),
          ],
        ),
      ),

    );
  }



  Widget _buttonUpdate(BuildContext context) { // Widget o metodo para crear botones
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30), //margen para el boton
      child: ElevatedButton(
          onPressed: () => con.goToProfileUpdate(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'ACTUALIZAR DATOS',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

  Widget _imageUser(BuildContext context) {
    return SafeArea( //metodo para bajar la imagen para que no sea tapada por el notch
      child: Container(
          margin: EdgeInsets.only(top: 30),
          alignment: Alignment.topCenter,
          child: CircleAvatar(
            backgroundImage: con.user.value.image != null //validacion la cual indica si un usuario selecciona una imagen la mostrara en el _imageUser de lo contrario dejara la que tiene por defecto
                ? NetworkImage(con.user.value.image!) //NetworkImage metodo para actualizar la imagen del usuario
                : AssetImage('assets/img/user_profile_2.png') as ImageProvider,
            radius: 60,
            backgroundColor: Colors.white,
          ),
      ),
    );
  }


  Widget _textName() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: ListTile(  //ListTile perimite ubicar una imagen con un texto
        leading: Icon(Icons.person),
        title:  Text('${con.user.value.name ?? ''} ${con.user.value.lastname ?? ''}'),
        subtitle: Text('Nombre del Usuario'),

      ),
    );
  }

  Widget _textEmail() {
    return ListTile(  //ListTile perimite ubicar una imagen con un texto
      leading: Icon(Icons.email),
      title: Text(con.user.value.email ?? ''),
      subtitle: Text('Email'),

    );
  }

  Widget _textPhone() {
    return ListTile(  //ListTile perimite ubicar una imagen con un texto
      leading: Icon(Icons.phone),
      title: Text(con.user.value.phone ?? ''),
      subtitle: Text('Telefono'),
    );
  }


}
