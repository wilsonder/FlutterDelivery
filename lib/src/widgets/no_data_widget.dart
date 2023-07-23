
import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {

  String text = '';

  NoDataWidget({this.text = ''}); //texto alternativo que se mostrara  cuando na haya ningun producto disponible en alguna de las categorias


 //Widget para la imagen de producto no disponible
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/img/cero-items.png',
            height: 150,
            width: 150,
          ),
          SizedBox(height: 15),
          Text(text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
