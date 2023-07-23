import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {

  HomeController con = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:  ElevatedButton(
          onPressed: () => con.signOut() ,
          child: Text('Cerrar Sesión',
          style: TextStyle(
            color: Colors.black
          ),),

        ),
      ),
    );
  }
}
