import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/home/client_home_controller.dart';
import 'package:flutter_delivery/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:flutter_delivery/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/categories/create/restaurant_categories_create_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/home/restaurant_home_controller.dart';
import 'package:flutter_delivery/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/products/create/restaurant_products_create_page.dart';
import 'package:flutter_delivery/src/utils/custom_animated_bottom_bar.dart';
import 'package:get/get.dart';

//Géstor de estados de la app

class RestaurantHomePage extends StatelessWidget {
  RestaurantHomeController con = Get.put(RestaurantHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomBar(),
      body: Obx (() => IndexedStack(
        index: con.indexTab.value,
        children: [
          RestaurantOrdersListPage(),
          RestaurantCategoriesCreatePage(),
          RestaurantProductsCreatePage(),
          ClientProfileInfoPage()
        ],
      ))
    );
  }

  //Widget para el bottom bar junto a sus configuraciones.
  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar (
      containerHeight: 70,
      backgroundColor: Colors.amber,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: con.indexTab.value,
      onItemSelected: (index) => con.changeTab(index),
      items: [
        BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text('Pedidos'),
            activeColor: Colors.white,
            inactiveColor: Colors.black,
        ),
        BottomNavyBarItem(
          icon: Icon(Icons.category),
          title: Text('Categoria'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),

        BottomNavyBarItem(
          icon: Icon(Icons.restaurant),
          title: Text('Producto'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        ),

        BottomNavyBarItem(
          icon: Icon(Icons.person),
          title: Text('Perfil'),
          activeColor: Colors.white,
          inactiveColor: Colors.black,
        )
      ],

    ));
  }
}
