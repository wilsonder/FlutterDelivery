
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ClientProductDetailController extends GetxController {


  void checkIfProductWasAdded(Product product, var price, var counter) {

    price.value = product.price ?? 0.0;

    if (GetStorage().read('shopping_bag') != null) {

      if (GetStorage().read('shopping_bag') is List<Product>) {

        selectedProducts = GetStorage().read('shopping_bag');

      }else {
        // aqui obtenemos los productos almaacenados en sesion
        selectedProducts = Product.fromJsonList(GetStorage().read('shopping_bag'));
      }

      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if (index != -1) {
        counter.value = selectedProducts[index].quantity ?? 0;
        price.value = product.price! * counter.value;

        // imprimir en consola los productos seleccionados
        selectedProducts.forEach((p) {
          print('Producto: ${p.toJson()}');
        });

      }
    }
  }

  List<Product> selectedProducts = [];
  ClientProductsListController productsListController = Get.find(); //instansear el controlador de listas de productos

  void addItems(Product product, var price, var counter) {
    counter.value = counter.value + 1;
    price.value = product.price! * counter.value; // multiplicacion para realizar el aumento del valor del contador
  }

  void addToBag(Product product, var price, var counter) {

    if (counter.value > 0) {

      //VALIDAR SI EL PRODUCTO YA FUE AGREGADO CON GETSTORAGE A LA SESION DEL DISPOSITIVO

      int index = selectedProducts.indexWhere((p) => p.id == product.id);

      if (index == -1) { // si el producto aun no ha sido agregado en storage
        if (product.quantity == null) {
          if (counter.value > 0) {
            product.quantity = counter.value;
          }else{
            product.quantity = 1;
          }

        }

        selectedProducts.add(product);

      } else { // significa que el producto ya ha sido agregado al storage
        selectedProducts[index].quantity = counter.value;
      }

      GetStorage().write('shopping_bag', selectedProducts); // se sobre escribe el getstorage para agregar los productos al carrito de compras.
      Fluttertoast.showToast(msg: 'Producto agregado');

      productsListController.items.value = 0;
      selectedProducts.forEach((p) {
        productsListController.items.value = productsListController.items.value + p.quantity!;
      });

    }else {
      Fluttertoast.showToast(msg: 'Debes seleccionar al menos un  item para agregar');
    }

  }

  void removeItems(Product product, var price, var counter) {

    if(counter.value > 0 ) {
      counter.value = counter.value - 1;
      price.value = product.price! * counter.value; // multiplicacion para realizar el aumento del valor del contador

    }
  }

}