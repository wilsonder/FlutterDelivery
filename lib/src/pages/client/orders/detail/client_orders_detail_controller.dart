import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/models/response_api.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/providers/orders_provider.dart';
import 'package:flutter_delivery/src/providers/users_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ClientOrdersDetailController extends GetxController{

  Order order = Order.fromJson(Get.arguments['order']);

  var total = 0.0.obs; //total a pagar
  var idDelivery = ''.obs; //id del usuario que se elgije del desplegable

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  ClientOrdersDetailController() {
    print('Order: ${order.toJson()}');
    getTotal();
  }



  void goToOrderMap() {
    Get.toNamed('/clients/orders/map',  arguments: {
      'order' : order.toJson()
    });
  }

  void getTotal() {
    total.value = 0.0;
    order.products!.forEach((product) {
      total.value = total.value + (product.quantity! * product.price!);
    });
  }

  }


