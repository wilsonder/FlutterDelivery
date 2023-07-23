import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/providers/categories_provider.dart';
import 'package:flutter_delivery/src/providers/products_provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class RestaurantProductsCreateController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();

  ImagePicker picker = ImagePicker();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;

  var idCategory = ''.obs;
  List<Category> categories = <Category> [].obs;
  ProductsProvider  productsProvider = ProductsProvider();

  RestaurantProductsCreateController() {
    getCategories();

  }

  void getCategories() async {
    var result  = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);
  }

  void createProduct(BuildContext context) async{
    String name = nameController.text;
    String description = descriptionController.text;
    String price = priceController.text;
    ProgressDialog progressDailog = ProgressDialog(context: context);

    if (isValidForm(name,description,price)) {

      Product product =  Product (
        name: name,
        description: description,
        price: double.parse(price),
        idCategory: idCategory.value
      );

      progressDailog.show(max: 100, msg: 'Espere un momento..');

      List<File> images = [];
      images.add(imageFile1!);
      images.add(imageFile2!);
      images.add(imageFile3!);

      Stream  stream = await productsProvider.create(product, images);
      stream.listen((res) {
        progressDailog.close();

        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));

        Get.snackbar('Proceso terminado', responseApi.message ?? '');

        if (responseApi.success == true) {
          clearForm();
        }



      });

    }

  }

  bool isValidForm(String name, String description, String price) {
    if (name.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el nombre del producto');
      return false;
    }

    if (description.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa la descripcion del producto');
      return false;
    }

    if (price.isEmpty) {
      Get.snackbar('Formulario no valido', 'Ingresa el precio del producto');
      return false;
    }

    if (idCategory.value == ' ') {
      Get.snackbar('Formulario no valido', 'Debes seleccionar la categoria del producto');
      return false;
    }

    if (imageFile1 == null) {
      Get.snackbar('Formulario no valido', 'Selecciona la imagen numero 1 del producto');
      return false;
    }

    if (imageFile2 == null) {
      Get.snackbar(
          'Formulario no valido', 'Selecciona la imagen numero 2 del producto');
      return false;
    }

      if (imageFile3 == null) {
        Get.snackbar('Formulario no valido', 'Selecciona la imagen numero 3 del producto');
        return false;
      }

      return true;

  }


  //metodo Future para seleccionar una imagen bien sea por camara o por galeria
  Future selectImage(ImageSource imageSource, int numberFile) async {
    XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {

      if (numberFile == 1) {
        imageFile1 = File(image.path);
      }else if (numberFile == 2) {
        imageFile2 = File(image.path);
      }else if (numberFile == 3) {
        imageFile3 = File(image.path);
      }

      update();
    }

  }

  //metodo para seleccionar foto de la galeria o la camara en el registro de usuarios

  void showAlertDialog(BuildContext context, int numberFile) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back(); //linea para que se cierre el alertDailog al seleccionar una opcion
          selectImage(ImageSource.gallery,numberFile);  //llmar a a la galeria por medio de la libreria image_picker

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
          selectImage(ImageSource.camera,numberFile);  //llmar a a la camara por medio de la libreria image_picker
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


  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
    priceController.text = '';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    idCategory.value = '';
    update();
  }

}