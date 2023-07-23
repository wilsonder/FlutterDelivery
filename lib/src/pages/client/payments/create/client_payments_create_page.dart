import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/glassmorphism_config.dart';
import 'package:flutter_delivery/src/models/mercado_pago_document_type.dart';
import 'package:flutter_delivery/src/pages/client/payments/create/client_payments_create_controller.dart';
import 'package:get/get.dart';

class ClientPaymentsCreatePage extends StatelessWidget {

  ClientPaymentsCreateController con = Get.put(ClientPaymentsCreateController());

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: Text('Pagos',
              style: TextStyle(
                  color: Colors.black
              )
          ),
        ),
      bottomNavigationBar: _buttonNext(context),
      body: ListView(
        children: [
          CreditCardWidget( //codigo de la tarjeta que se encuantra en la documentacion de flutter https://pub.dev/packages/flutter_credit_card
            cardNumber: con.cardNumber.value,
            expiryDate: con.expireDate.value,
            cardHolderName: con.cardHolderName.value,
            cvvCode: con.cvvCode.value,
            showBackView: con.isCvvFocused.value,
            cardBgColor: Colors.amber,
            obscureCardNumber: true,
            obscureCardCvv: true,
            height: 175,
            labelCardHolder: 'NOMBRE Y APELLIDO',
            textStyle: TextStyle(color: Colors.black),
            width: MediaQuery.of(context).size.width,
            animationDuration: Duration(milliseconds: 1000),
            onCreditCardWidgetChange: (CreditCardBrand ) {  },
            glassmorphismConfig: Glassmorphism(
              blurX: 10.0,
              blurY: 10.0,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Colors.grey.withAlpha(50),
                  Colors.black.withAlpha(50),
                ],
                stops: const <double>[
                  0.3,
                  0,
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: CreditCardForm(
              formKey: con.keyform, // Required
              onCreditCardModelChange: con.oncreditCardModelChanged, // Required
              themeColor: Colors.red,
              obscureCvv: true,
              obscureNumber: true,
              cardNumberValidator: (String? cardNumber){},
              expiryDateValidator: (String? expiryDate){},
              cvvValidator: (String? cvv){},
              cardHolderValidator: (String? cardHolderName){},
              onFormComplete: () {
                // callback to execute at the end of filling card data
              },
              cardNumberDecoration: const InputDecoration(
                suffixIcon: Icon(Icons.credit_card),
                labelText: 'Numero de la tarjeta',
                hintText: 'XXXX XXXX XXXX XXXX',
              ),
              expiryDateDecoration: const InputDecoration(
                suffixIcon: Icon(Icons.date_range),
                labelText: 'Expiración',
                hintText: 'MM/YY',
              ),
              cvvCodeDecoration: const InputDecoration(
                suffixIcon: Icon(Icons.lock),
                labelText: 'CVV',
                hintText: 'XXX',
              ),
              cardHolderDecoration: const InputDecoration(
                suffixIcon: Icon(Icons.person),
                labelText: 'Titular de la tarjeta',
              ), cvvCode: '',
                 cardNumber: '',
                 expiryDate: '',
                 cardHolderName: '',
            ),
          ),
          _dropDownWidget(con.documents),
          _textFieldDocumentNumber()
        ],
      )
    ));
  }

  Widget _textFieldDocumentNumber() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 37, vertical: 10),
      child: TextField(
        controller: con.documentNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
            hintText: 'Numero de documento',
            suffixIcon: Icon(Icons.description) //prefixIcon establece un icono al textfield
        ),
      ),
    );
  }

  Widget _buttonNext(BuildContext context) { // Widget o metodo paraa crear botones
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40), //margen para el boton
      child: ElevatedButton(
          onPressed: () => con.createCardToken(),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            'CONTINUAR',
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

  Widget _dropDownWidget(List<MercadoPagoDocumentType> documents) {
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
          'Seleccionar tipo de documento',
          style: TextStyle(
              fontSize: 15
          ),
        ),

        items: _dropDownItems(documents),
        value: con.idDocument.value == '' ? null: con.idDocument.value,
        onChanged: (option) {
          con.idDocument.value = option.toString();
        },

      ),
    );
  }

  List<DropdownMenuItem<String?>> _dropDownItems(List<MercadoPagoDocumentType> documents) {

    List<DropdownMenuItem<String>> list = [];
    documents.forEach((document) {
      list.add(DropdownMenuItem(child: Text(
          document.name ?? '' ),
        value: document.id,
      ));

    });

    return list;

  }


}
