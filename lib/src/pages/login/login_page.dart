import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginPage extends StatelessWidget {

  LoginController con = Get.put(LoginController()); //de esta manera se importa un controller al page

  @override
  Widget build(BuildContext context) {
    return Scaffold( //el Scaffold es similar al html es  donde se agregan los componentes de las pantallas
      bottomNavigationBar: Container( //bottomNavigationBar posiciona elmentos en la parte de abajo de la pantalla
        height: 50,
        child: _textDontHaveAccount(),
      ),
      body: Stack(  //Stack sirve para posicionar elementos uno encima del otro
        children: [
          _backgroundCover(context),
          _boxForm(context),
          Column( // Column sirve para posicionar elementos uno debajo del otro de manera vertical
            children: [
              _imageCover(),
              _textAppName()
            ],
          )
        ],
      )
    );
  }

  // un _ antes del nombre del metodo significa que es privado de lo contrario es publico
  Widget _textAppName() {
    return Text(
      'DELIVERY APP',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
    );
  }

  Widget _boxForm(BuildContext context) {  //BuildContext parametro para trabajar con porcentajes o resolucion de pantalla
    return Container(
      height: MediaQuery.of(context).size.height * 0.45, // este metodo agranda el container amarillo y a su vez lo hace responsive adaptandolo a cuaalquier tipo de pantalla
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.36, left: 50, right: 50),
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
            _textFieldEmail(),
            _textFieldPassword(),
            _buttonLogin()
          ],
        ),
      ),

    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo electronico',
          prefixIcon: Icon(Icons.email) //prefixIcon establece un icono al textfield
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.passwordController,
        keyboardType: TextInputType.text, // aqui se establece el tipo de texto
        obscureText: true, // esta propiedad oculta el texto cuando escribo la contraseña
        decoration: InputDecoration(
            hintText: 'Contraseña',
            prefixIcon: Icon(Icons.lock)
        ),
      ),
    );
  }
  
  Widget _buttonLogin() { // Widget o metodo para crear botones
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40), //margen para el boton
      child: ElevatedButton(
          onPressed: () => con.login(),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'LOGIN',
            style: TextStyle(
            color: Colors.black
      ),
          )
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 45),
      child: Text(
        'INGRESA ESTA INFORMACIÓN',
        style: TextStyle(
         color: Colors.black
        ),
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row( // Row nos permite ubicar elementos uno al lado del otro de manera horizontal
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿No tienes cuenta?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17
          ),
        ),
        SizedBox(width: 7), //separacion de los textos
        GestureDetector( //GestureDetector metodo para redireccionar cuando el usuario seleccione este texto
          onTap: () => con.GoToRegisterPage() , //Redireccion al GoToRegisterPage que se encuentra en el login_controller
          child: Text(
            'Registrate Aquí',
            style: TextStyle(
              color: Colors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 17
            ),

          ),
        )
      ],
    );
  }

  Widget _backgroundCover(BuildContext context) { //BuildContext parametro para trabajar con porcentajes o resolucion de pantalla
    return Container(
      width: double.infinity, //double.infinity indica que va a ocupar todo el ancho  de la pantala
      height: MediaQuery.of(context).size.height * 0.42, // este metodo agranda el container amarillo y a su vez lo hace responsive adaptandolo a cuaalquier tipo de pantalla
      color: Colors.amber// Colors establece el color amarillo para el backgrund

    );
  }

  // un _ antes del nombre del metodo significa que es privado de lo contrario es publico
  Widget _imageCover() {
    return SafeArea( // este metodo sirve para dar margin top al widget
      child: Container(
        margin: EdgeInsets.only(top: 50,bottom: 15), // estabce margin top a la imagen
        alignment: Alignment.center, //centrar la imagen y el texto
        child: Image.asset(
          'assets/img/delivery2.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
