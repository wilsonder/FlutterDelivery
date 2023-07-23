import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/environment/environment.dart';
import 'package:flutter_delivery/src/models/order.dart';
import 'package:flutter_delivery/src/providers/orders_provider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';

class ClientOrdersMapController extends GetxController {

  Socket socket = io('${Environment.API_URL}orders/delivery', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  Order order = Order.fromJson(Get.arguments['order'] ?? {});
  OrdersProvider ordersProvider = OrdersProvider();

  //configuracion de l mapa de google

  CameraPosition initialPosition = CameraPosition(
    target: LatLng(5.6911313, -73.9235671), //latitud y longitud de una posicion central a la la ciudad donde nos encontramos se obtiene directamnte de google maps
    zoom: 14
  );

  LatLng? addressLatLng;
  var addressName = ''.obs;

  Completer<GoogleMapController> mapController = Completer();
  Position?  position;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs; //variable para para agregar marcadores personalizados al mapa.
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  StreamSubscription? positionSubscribe; //variable para obtener nuestra posicion en tiempo real.

  Set<Polyline> polylines = <Polyline> {}.obs;
  List<LatLng> points = [];

  //metodo para guardar la direcccion selecccioanada en el mapa para posteriormente añadirla ala Texfield
  void selectRefPoint(BuildContext context) {
    if(addressLatLng != null) {
      Map<String, dynamic> data = {
        'address': addressName.value,
        'lat': addressLatLng!.latitude,
        'lng': addressLatLng!.longitude,
      };
      Navigator.pop(context, data);
    }

  }

  Future<BitmapDescriptor> createMarkerFromAssets(String path) async{
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.fromAssetImage(
        configuration, path
    );

    return descriptor;

  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
  ) {
      MarkerId id = MarkerId(markerId);
      Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content)
      );

      markers[id] = marker;
      update();

  }


  ClientOrdersMapController() {
    print('Orden: ${order.toJson()}');
    checkGPS();  // verificar si el gps del celular esta activo y tambienm requerir los permisos respectivos
    connectAndListen();

  }

  void connectAndListen() {
    socket.connect();
    socket.onConnect((data) {
      print('ESTE DISPOSITIVO SE CONECTO A SOCKET IO');
    });

    listenPosition();
    listenToDelivered();

  }

  void listenPosition() {
    socket.on('position/${order.id}', (data)  {

      addMarker('delivery', data['lat'] , data['lng'], 'Tu repartidor', '', deliveryMarker!);

    });
  }

  void listenToDelivered() {
    socket.on('delivered/${order.id}', (data)  {
      Fluttertoast.showToast(msg: 'El estado de la orden se actualizó a entregado', toastLength: Toast.LENGTH_LONG);
      Get.offNamedUntil('/client/home', (route) => false);

      //addMarker('delivery', data['lat'] , data['lng'], 'Tu repartidor', '', deliveryMarker!);

    });
  }

  // metodo para obtener la direccion a medida que se mueve el icono de direccion
  Future setLocationDraggableInfo() async{


    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> address = await placemarkFromCoordinates(lat,lng);

    if(address.isNotEmpty) {
      String direction = address[0].thoroughfare ?? '';
      String street = address[0].thoroughfare ?? '';
      String city = address[0].locality ?? '';
      String department = address[0].administrativeArea ?? '';
      String country = address[0].country ?? '';
      addressName.value = '$direction #$street, $city, $department';
      addressLatLng = LatLng(lat, lng);

    }

  }


  //preguntar si el gps del celular esta activo
  void checkGPS() async {

    deliveryMarker = await createMarkerFromAssets('assets/img/delivery_little.png'); //imagen del delivery que se marca en el mapa
    homeMarker = await createMarkerFromAssets('assets/img/home.png'); //imagen del delivery que se marca en el mapa

    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if(isLocationEnabled == true) {
      updateLocation();
    }else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS == true) {
        updateLocation();
      }
    }
  }

  //metodo para trzar la ruta entre el repartidor y el punto de entrega
  Future<void> setPolylines(LatLng from, LatLng to) async {
    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFrom,
        pointTo
    );

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
        color: Colors.amber,
        points: points,
        width: 7
    );

    polylines.add(polyline);
    update();

  }


  // metodod para obtner nuestra ubicacion actual desde el celular.
  void updateLocation() async {
    try{
      await _determinePosition();
      position = await Geolocator.getLastKnownPosition(); //obtener la latiitud y longitud de nuestra posicion actual
      saveLocation();
      animatedCameraPosition(order.lat ?? 5.6911313, order.lng ?? -73.9235671);
      addMarker('delivery', order.lat ?? 5.6911313 , order.lng ?? -73.9235671, 'Tu repartidor', '', deliveryMarker!);
      addMarker(
          'home',
          order.address!.lat ??  5.6911313,
          order.address!.lng ?? -73.9235671,
          'Lugar de entrega',
          '',
          homeMarker!
      );
     // addMarker('home',  5.6880918, -73.9240313, 'Lugar de entrega', '', homeMarker!);

      //print('ROTA ORDEN :): ${order.address}');

      LatLng from = LatLng(order.lat ??  5.6911313 ,order.lng ?? -73.9235671);
      LatLng to = LatLng(order.address?.lat ?? 5.6898736 ,order.address?.lng ?? -73.9228288);

      setPolylines(from, to);


    }catch(e) {
      print('Error ${e}');
    }

    update();
  }


  //metodo para guardar la latitud y la longitud de nuestra ubicacion en la base de datos (tabla Orders)
  void saveLocation() async {
    if(position != null) {
      order.lat = position!.latitude;
      order.lng = position!.longitude;
      await ordersProvider.updateLatLng(order);
    }
  }

  //metodo para programaar el boton para centrar la localizacion del en el mapa

  void centerPosition() {
    if(position != null) {
      animatedCameraPosition(position!.latitude, position!.longitude);
    }
  }

  //metodo para realizar llamadas telefonicas
 void  callNumber() async{
    String  number = order.delivery?.phone ?? ''; //set the number here
     await FlutterPhoneDirectCaller.callNumber(number);
  }


  Future animatedCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(lat,lng),
          zoom: 13,
          bearing: 0
      )
    ));
  }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;


    //meoodo para preguntar si hemos concedido permiso paraa obtener la localizacion en nuestro dispositivo
    // esto se obtiene de la documentacion de la libreria geolocator

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }


  void onMapCreate(GoogleMapController controller) {
    // en esta linea se aplica el respectivo estilo del mapa de google
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]'); // aplicar estilos ala mapa de google

    mapController.complete(controller);

  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    socket.disconnect();
    positionSubscribe?.cancel();
  }

}