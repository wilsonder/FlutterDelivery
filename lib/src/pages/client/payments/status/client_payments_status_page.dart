import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/pages/client/payments/status/client_payments_status_controller.dart';
import 'package:get/get.dart';

class ClientPaymentsStatusPage extends StatelessWidget {

  ClientPaymentsStatusController con = Get.put(ClientPaymentsStatusController());

  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(  //Stack sirve para posicionar elementos uno encima del otro
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _textFinishTransaction(context),

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
      child: Column(
        children: [
          _textTransactionDetail(),
          _textTransactionStatus(),
          Spacer(),
          _buttonCreate(context)
        ],
      ),

    );
  }

  Widget _buttonCreate(BuildContext context) { // Widget o metodo paraa crear botones
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20), //margen para el boton
      child: ElevatedButton(
          onPressed: () => con.finishShopping(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'FINALIZAR COMPRA',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

  Widget _textFinishTransaction(BuildContext context) {
    return SafeArea( //metodo para bajar la imagen para que no sea tapada por el notch
      child: Container(
        margin: EdgeInsets.only(top: 15),
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            con.mercadoPagoPayment.status == 'approved' ?
            Icon(Icons.check_circle, size: 100, color: Colors.green) :
            Icon(Icons.cancel, size: 100, color: Colors.red),
            Text('TRANSACCION TERMINADA',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23
              ),),
          ],
        ),
      ),
    );
  }

  Widget _textTransactionDetail() {
    return Container(
      margin: EdgeInsets.only(top: 40, bottom: 30,left: 25,right: 25),
      child: Text(
        con.mercadoPagoPayment.status == 'approved' ?
        'Tu orden fue procesada exitosamente(${con.mercadoPagoPayment.paymentMethodId?.toUpperCase()} **** ${con.mercadoPagoPayment.card?.lastFourDigits})'
        : 'Tu pago fue rechazado',
        style: TextStyle(
            color: Colors.black
        ),
      ),
    );
  }

  Widget _textTransactionStatus() {
    return Container(
      margin: EdgeInsets.only(bottom: 30,left: 25,right: 25),
      child: Text(
        con.mercadoPagoPayment.status == 'approved' ?
        'Mira el estado de tu compra en la sección de mis pedidos'
            : con.errorMessage.value,
        style: TextStyle(
            color: Colors.black
        ),
      ),
    );
  }

}
