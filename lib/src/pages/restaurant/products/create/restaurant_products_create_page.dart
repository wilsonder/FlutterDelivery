import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/pages/restaurant/categories/create/restaurant_categories_create_controller.dart';
import 'package:flutter_delivery/src/pages/restaurant/products/create/restaurant_products_create_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RestaurantProductsCreatePage extends StatelessWidget {

  RestaurantProductsCreateController con = Get.put(RestaurantProductsCreateController());

  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx (() => Stack(  //Stack sirve para posicionar elementos uno encima del otro
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _textNewCategory(context),

          ],
        )),
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
      height: MediaQuery.of(context).size.height * 0.7, // este metodo agranda el container amarillo y a su vez lo hace responsive adaptandolo a cuaalquier tipo de pantalla
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.18, left: 50, right: 50),
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
            _textFieldPrice(),

            _dropDownCategories(con.categories),

            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<RestaurantProductsCreateController>(builder: (value) =>  _cardImage(context, con.imageFile1, 1)
                  ),
                  SizedBox(width: 5),
                  GetBuilder<RestaurantProductsCreateController>(builder: (value) =>  _cardImage(context, con.imageFile2, 2)
                  ),
                  SizedBox(width: 5),
                  GetBuilder<RestaurantProductsCreateController>(builder: (value) =>  _cardImage(context, con.imageFile3, 3)
                  ),
                ],
              ),
            ),


            _buttonCreate(context)
          ],
        ),
      ),

    );
  }

  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          'Seleccionar categoria',
          style: TextStyle(
            fontSize: 15
          ),
        ),

        items: _dropDownItems(categories),
        value: con.idCategory.value == '' ? null: con.idCategory.value,
        onChanged: (option) {
          con.idCategory.value = option.toString();
        },

      ),
    );
  }

  List<DropdownMenuItem<String?>> _dropDownItems(List<Category> categories) {

    List<DropdownMenuItem<String>> list = [];
    categories.forEach((category) {
      list.add(DropdownMenuItem(child: Text(
          category.name ?? '' ),
          value: category.id,
      ));

    });

    return list;

  }
  
  //card image para pober la iamgen capturada

  Widget _cardImage(BuildContext context, File? imageFile, int numberFile) {
    return GetBuilder<RestaurantProductsCreateController> ( //coloca la imagen en el _imageUser una vez se haya seleccionado
        builder: (value) =>
            GestureDetector(
              onTap: () => con.showAlertDialog(context, numberFile),
              child: Card (
                elevation: 3,
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: 70,
                    width: MediaQuery.of(context).size.width * 0.18,
                    child:  imageFile != null ? Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    )
                        : Image(
                      image: AssetImage('assets/img/cover_image.png'),
                    )
                ),
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

  Widget _textFieldPrice() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: con.priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            hintText: 'Precio',
            prefixIcon: Icon(Icons.attach_money) //prefixIcon establece un icono al textfield
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
          onPressed: () => con.createProduct(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'CREAR PRODUCTO',
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
          margin: EdgeInsets.only(top: 25),
          alignment: Alignment.topCenter,
          child: Text('NUEVO PRODUCTO',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23
            ),
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
