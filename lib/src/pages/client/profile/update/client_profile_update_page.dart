import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'client_profile_update_controller.dart';


class ClientProfileUpdatePage extends StatelessWidget {
  ClientProfieUpdateController con = Get.put(ClientProfieUpdateController());

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(  //Stack sirve para posicionar elementos uno encima del otro
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _imageUser(context),
            _buttonBack(),

          ],
        )
    );
  }

  Widget _buttonBack() {
    return SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.arrow_back_ios,
              color: Colors.white,
              size: 30,
            ),
          ),
        )
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
      height: MediaQuery.of(context).size.height * 0.45, // este metodo agranda el container amarillo y a su vez lo hace responsive adaptandolo a cuaalquier tipo de pantalla
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
            _textYourInfo(),
            _textFieldName(),
            _textFieldLastName(),
            _textFieldLastPhone(),
            _buttonUpdate(context)
          ],
        ),
      ),

    );
  }


  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Nombre',
            prefixIcon: Icon(Icons.person) //prefixIcon establece un icono al textfield
        ),
      ),
    );
  }
  Widget _textFieldLastName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.lastnameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: 'Apellido',
            prefixIcon: Icon(Icons.person_outlined) //prefixIcon establece un icono al textfield
        ),
      ),
    );
  }
  Widget _textFieldLastPhone() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Teléfono',
            prefixIcon: Icon(Icons.phone) //prefixIcon establece un icono al textfield
        ),
      ),
    );
  }


  Widget _buttonUpdate(BuildContext context) { // Widget o metodo paraa crear botones
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40), //margen para el boton
      child: ElevatedButton(
          onPressed: ()=> con.updateInfo(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'ACTUALIZAR',
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
          child: GestureDetector ( //GestureDetector evento de click
            onTap: () => con.showAlertDialog(context),
            child: GetBuilder<ClientProfieUpdateController> ( //coloca la imagen en el _imageUser una vez se haya seleccionado
              builder: (value) => CircleAvatar(
                backgroundImage: con.imageFile != null //validacion la cual indica si un usuario selecciona una imagen la mostrara en el _imageUser de lo contrario dejara la que tiene por defecto
                    ? FileImage(con.imageFile!)
                    : con.user.image != null // validar si el usuario ya tiene cargada una imagen y si la tiene que la cargue
                    ? NetworkImage(con.user.image!)
                    : AssetImage('assets/img/user_profile_2.png') as ImageProvider,
                radius: 60,
                backgroundColor: Colors.white,
              ),
            ),
          )
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 30),
      child: Text(
        'INGRESA ESTA INFORMACIÓN',
        style: TextStyle(
            color: Colors.black
        ),
      ),
    );
  }
}
