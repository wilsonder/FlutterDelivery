import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/pages/client/products/detail/client_products_detail_page.dart';
import 'package:flutter_delivery/src/providers/categories_provider.dart';
import 'package:flutter_delivery/src/providers/products_provider.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClientProductsListController extends GetxController {

  CategoriesProvider categoriesProvider = CategoriesProvider();
  ProductsProvider productsProvider = ProductsProvider();

  List<Product> selectedProducts = [];

  List<Category> categories = <Category>[].obs;
  var items = 0.obs;

  var productName = ''.obs; //variable para buscar un producto por el nombre
  Timer? searchOnStoppedTyping;

  ClientProductsListController() {
    getCategories();

    if (GetStorage().read('shopping_bag') != null) {
      if (GetStorage().read('shopping_bag') is List<Product>) {
        selectedProducts = GetStorage().read('shopping_bag');
      }else {
        // aqui obtenemos los productos almaacenados en sesion
        selectedProducts = Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      ///sumar la cantidades para la bola de compras

      selectedProducts.forEach((p) {
        items.value = items.value + (p.quantity!);
      });

    }
  }

  //metodo para realizar la peticion al Backend cuando se busca un producto una vez se termine de escribir una palabra para no sobrecargar el servidor con las busquedas
  void onChangeText(String text) {
    const duration = Duration(milliseconds: 800);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel();
    }
    searchOnStoppedTyping = Timer(duration, () {
      productName.value = text;
      print('TEXTO COMPLETO: ${text}');
    });
  }

  //metodo para traer las categoriass

  void getCategories() async {
    var result = await categoriesProvider.getAll();
    categories.clear();
    categories.addAll(result);

  }

  // metodo que nos retorna una lista de tipo product para enlistar los productos por categorias
  Future<List<Product>> getProducts(String idCategory, String name) async {

    if (productName.isEmpty) {
      return await productsProvider.findByCategory(idCategory);
    }else{
      return await productsProvider.findByNameAndCategory(idCategory, name);
    }

  }

  void goToOrderCreate() {
    Get.toNamed('/clients/orders/create'); //redireccionar a lña pagian de ordenes de compra la cual es client_orders_create_page.dart
  }

  // metodo para abrir el modal que mostrará el detalle de los productos disponibles
  void openBottomSheet(BuildContext context, Product product) {
    showBarModalBottomSheet(
        context: context,
        builder: (context) => ClientProductsDetailPage(product: product)  //aqui llamamos el producto.
    );
  }

}