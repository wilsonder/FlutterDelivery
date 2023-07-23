import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/providers/categories_provider.dart';
import 'package:get/get.dart';

class RestaurantCategoriesCreateController extends GetxController {

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  CategoriesProvider categoriesProvider = CategoriesProvider();


  void createCategory() async{
    String name = nameController.text;
    String description = descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      Category category = Category (
        name: name,
        description: description,
      );

      ResponseApi responseApi = await categoriesProvider.create(category); //aqui se crea la categoria llamando el ResponseApi del categories_provider

      if (responseApi.success == true) {

        clearForm();

      }

      Get.snackbar('Proceso terminado', responseApi.message ?? '');

    }else{
      Get.snackbar('Formulario no valido', 'Ingresa todos los campos para crear la categoria');
    }

  }

  void clearForm() {
    nameController.text = '';
    descriptionController.text = '';
  }

}