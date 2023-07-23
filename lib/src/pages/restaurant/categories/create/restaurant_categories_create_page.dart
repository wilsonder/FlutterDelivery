import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:get/get.dart';

class RestaurantCategoriesCreatePage extends StatelessWidget {

  RestaurantCategoriesCreateController con = Get.put(RestaurantCategoriesCreateController());

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(  //Stack sirve para posicionar elementos uno encima del otro
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _textNewCategory(context),

          ],
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
            _textFieldDescription(),
            _buttonCreate(context)
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
            prefixIcon: Icon(Icons.category) //prefixIcon establece un icono al textfield
        ),
      ),
    );
  }
  Widget _textFieldDescription() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: TextField(
        controller: con.descriptionController,
        keyboardType: TextInputType.text,
        maxLines: 4,
        decoration: InputDecoration(
            hintText: 'Descripción',
            prefixIcon: Container(
              margin: EdgeInsets.only(bottom: 50),
                child: Icon(Icons.description)) //prefixIcon establece un icono al textfield
        ),
      ),
    );
  }


  Widget _buttonCreate(BuildContext context) { // Widget o metodo paraa crear botones
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20), //margen para el boton
      child: ElevatedButton(
          onPressed: () => con.createCategory(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'CREAR CATEGORÍA',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

  Widget _textNewCategory(BuildContext context) {
    return SafeArea( //metodo para bajar la imagen para que no sea tapada por el notch
      child: Container(
          margin: EdgeInsets.only(top: 15),
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Icon(Icons.category, size: 100),
              Text('NUEVA CATEGORIA',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23
              ),),
            ],
          ),
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
