import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/category.dart';
import 'package:flutter_delivery/src/models/product.dart';
import 'package:flutter_delivery/src/pages/client/products/list/client_products_list_controller.dart';
import 'package:flutter_delivery/src/widgets/no_data_widget.dart';
import 'package:get/get.dart';

//Géstor de estados de la app

class ClientProductsListPage extends StatelessWidget {
  ClientProductsListController con = Get.put(ClientProductsListController());

  @override
  Widget build(BuildContext context) {

    //barra para traer los tabs para las distintas categorias de la lista de Productos del modulo cliente
    return Obx(() => DefaultTabController(
        length: con.categories.length,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(110),
            child: AppBar(
              flexibleSpace: Container(
                margin: EdgeInsets.only(top: 15),
                alignment: Alignment.topCenter,
                child: Wrap(
                  direction: Axis.horizontal,
                  children: [
                    _textFieldSearch(context),
                    _iconShoppingBag()
                  ],
                ),
              ),
              bottom: TabBar(
                isScrollable: true,
                indicatorColor: Colors.amber,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                tabs: List<Widget>.generate(con.categories.length, (index) {
                  return Tab(
                    child: Text(con.categories[index].name ?? ''),
                  );
                }),
              ),
            ),
          ),
          body: TabBarView(
            children: con.categories.map((Category category) {
              return FutureBuilder(
                  future: con.getProducts(category.id ?? '1', con.productName.value),
                  builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                    if(snapshot.hasData) {

                      if (snapshot.data!.length > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (_, index) {
                              return _cardProduct(context, snapshot.data![index]);
                            }
                        );
                      }else {
                        return NoDataWidget(text: 'No hay productos'); //aqui llamamos la iamgen para producto no disponible del no_data_widget
                      }
                    }else {
                      return NoDataWidget(text: 'No hay productos');
                    }
                  }
              );
            }).toList(),
          ),
        ),
    ));

  }

  //wiget paara realizar el buscador de productos
  Widget _textFieldSearch(BuildContext context) {
    return SafeArea(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        child: TextField(
          onChanged: con.onChangeText, //al momento de escribir dispara una funcion
          decoration: InputDecoration(
            hintText: 'Buscar Productos',
            suffixIcon: Icon(Icons.search, color: Colors.grey),
            hintStyle: TextStyle(
              fontSize: 17,
              color: Colors.grey
            ),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.grey
              )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                    color: Colors.grey
                )
            ),
            contentPadding: EdgeInsets.all(15)
          ),

        ),
      ),
    );
  }

  Widget _iconShoppingBag() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: con.items.value > 0 ? Stack(
          children: [
            IconButton(
                onPressed: () => con.goToOrderCreate() ,
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  size: 30,
                )
            ),
            Positioned(
              right: 7,
              top: 12,
                child: Container(
                  width: 16,
                  height: 16,
                  alignment: Alignment.center,
                  child: Text('${con.items.value}', style:
                    TextStyle(
                      fontSize: 12
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                )
            )
          ],
        )
        : IconButton(
            onPressed: () => con.goToOrderCreate() ,
            icon: Icon(
              Icons.shopping_bag_outlined,
              size: 35,
            )
        ),
      ),
    );
  }


  // card para listar cada uno de los productos
  Widget _cardProduct(BuildContext context,  Product product) {
    return GestureDetector(
      onTap: () => con.openBottomSheet(context, product), //llamar el modal para el detalle del producto
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: 20, right: 20),
            child: ListTile(
              title: Text(product.name ?? '') ,
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.description ?? '',
                    maxLines: 2, //maximo de lineas para la descripcion.
                    style: TextStyle(
                      fontSize: 13
                    ),
                  ),
                  SizedBox(height: 5),
                    Text('\$${product.price.toString()}', //signo de pesos
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              trailing: Container(
                height: 70,
                width: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FadeInImage(
                    image: product.image1 != null
                    ? NetworkImage(product.image1!)
                    : AssetImage('assets/img/no-image.png') as ImageProvider,
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 50),
                    placeholder: AssetImage('assets/img/no-image.png'),
                  ),
                ),
              ),
            ),
          ),
          Divider( height: 1, color: Colors.grey[300], indent: 37, endIndent: 37 ,)
        ],
      ),
    );
  }


}
