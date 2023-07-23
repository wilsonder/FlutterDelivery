import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/pages/client/products/detail/client_products_detail_controller.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';

class ClientProductsDetailPage extends StatelessWidget {

  Product? product;
  late  ClientProductDetailController con; //late indica que la variable se va a inicializar en un momento dado.
  var counter = 0.obs; //variable para hacer el contador de productos
  var price = 0.0.obs;

  // en esta hacemos obligatorio llamar al producto con el metodo @required
  ClientProductsDetailPage({@required this.product}) {

    con = Get.put(ClientProductDetailController());

  }


  @override
  Widget build(BuildContext context) {

    con.checkIfProductWasAdded(product!, price, counter);

    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(245, 245, 245, 1.0),
        height: 100,
          child: _buttonsAddToBag()
      ),

      body: Column(
        children: [
          _imageSlideshow(context),
          _textNameProduct(),
          _textDescriptionProduct(),
          _textPriceProduct()
        ],
      )
    ));
  }

  Widget _textNameProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Text(
        product?.name ?? '',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black
        ),
      ),
    );
  }

  // Widget para agregar la descripcion del producto
  Widget _textDescriptionProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      child: Text(
        product?.description ?? '',
        style: TextStyle(
            fontSize: 16,
            color: Colors.black
        ),
      ),
    );
  }

  // Widget para agregar el precio del producto
  Widget _textPriceProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 15, left: 30, right: 30),
      child: Text(
         '\$${product?.price ?? ''}' ,
        style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

 //Widget para añaadir la cantidad de producto a comprar
  Widget _buttonsAddToBag() {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300]),
        Container(
          margin: EdgeInsets.only(left: 25, right: 30, top: 25),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => con.removeItems(product!,price,counter),
                child: Text(
                  '-',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(45, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        )
                    )
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  '${counter.value}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  minimumSize: Size(40, 37)

                ),
              ),
              ElevatedButton(
                onPressed: () => con.addItems(product!,price,counter),
                child: Text(
                  '+',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    minimumSize: Size(45, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(25),
                          bottomRight: Radius.circular(25),
                        )
                    )
                ),
              ),

             Spacer(), //etiqueta que nos alinea el boton de agregar a la izquierda

              ElevatedButton(
                  onPressed: () => con.addToBag(product!,price,counter),
                  child: Text(
                    'Agregar  \$${price.value}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.amber,
                      shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(25)
                      )
                  )
              ),
            ],
          ),
        )

      ],
    );

  }



  // en este widget llamamos las respectivas imagenes para el slider del detalle del productos
  Widget _imageSlideshow(BuildContext context) {
    return ImageSlideshow(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      initialPage: 0,
      indicatorColor: Colors.amber,
      indicatorBackgroundColor: Colors.grey,
      children: [
        FadeInImage(
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 50),
            placeholder: AssetImage('assets/img/no-image.png'),
            image: product!.image1 != null
                ? NetworkImage(product!.image1!)
                : AssetImage('assets/img/no-image.png') as ImageProvider
        ),
        FadeInImage(
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 50),
            placeholder: AssetImage('assets/img/no-image.png'),
            image: product!.image2 != null
                ? NetworkImage(product!.image2!)
                : AssetImage('assets/img/no-image.png') as ImageProvider
        ),
        FadeInImage(
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 50),
            placeholder: AssetImage('assets/img/no-image.png'),
            image: product!.image3 != null
                ? NetworkImage(product!.image3!)
                : AssetImage('assets/img/no-image.png') as ImageProvider
        )
      ],
    );
  }
}
