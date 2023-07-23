import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_delivery/src/models/user.dart';
import 'package:flutter_delivery/src/pages/client/address/create/client_address_create_page.dart';
import 'package:flutter_delivery/src/pages/client/address/list/client_adress_list_page.dart';
import 'package:flutter_delivery/src/pages/client/home/client_home_page.dart';
import 'package:flutter_delivery/src/pages/client/orders/create/client_orders_create_page.dart';
import 'package:flutter_delivery/src/pages/client/orders/detail/client_orders_detail_page.dart';
import 'package:flutter_delivery/src/pages/client/orders/map/client_orders_map_page.dart';
import 'package:flutter_delivery/src/pages/client/payments/create/client_payments_create_page.dart';
import 'package:flutter_delivery/src/pages/client/payments/installments/client_payments_installments_page.dart';
import 'package:flutter_delivery/src/pages/client/payments/status/client_payments_status_page.dart';
import 'package:flutter_delivery/src/pages/client/products/list/client_products_list_page.dart';
import 'package:flutter_delivery/src/pages/client/profile/info/client_profile_info_page.dart';
import 'package:flutter_delivery/src/pages/client/profile/update/client_profile_update_page.dart';
import 'package:flutter_delivery/src/pages/delivery/home/delivery_home_page.dart';
import 'package:flutter_delivery/src/pages/delivery/orders/detail/delivery_orders_detail_page.dart';
import 'package:flutter_delivery/src/pages/delivery/orders/list/delivery_orders_list_page.dart';
import 'package:flutter_delivery/src/pages/login/login_page.dart';
import 'package:flutter_delivery/src/pages/register/register_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/home/restaurant_home_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/orders/detail/restaurant_orders_detail_page.dart';
import 'package:flutter_delivery/src/pages/restaurant/orders/list/restaurant_orders_list_page.dart';
import 'package:flutter_delivery/src/pages/roles/roles_page.dart';
import 'package:flutter_delivery/src/providers/push_notifications_provider.dart';
import 'package:flutter_delivery/src/utils/firebase_config.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'src/pages/delivery/orders/map/delivery_orders_map_page.dart';
import 'src/pages/home/home_page.dart';

User userSession = User.fromJson(GetStorage().read('user') ?? {}); //linea para mantener la sesion abierta asi se cierre la aplicacion

PushNotificationsProvider pushNotificationProvider = PushNotificationsProvider();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform);
  print('Recibiendo notificacion en segundo plano ${message.messageId}');
  //                pushNotificationProvider.showNotification(message);
}

void main() async{
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: FirebaseConfig.currentPlatform); //linea para dtectar el tipo de dispositivo al que nos conectamos para el envio de notificaciones
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler); //linea para recibir notificaciones con el celular apagado o con la aplicacion cerrada
  pushNotificationProvider.initPushNotifications(); //iniciarv notificaciones
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() { // este método muestra las acciones al momento de correr la aplicacion
    // TODO: implement initState
    super.initState();

    print('EL TOKEN DE SESION DEL USUARIO: ${userSession.sessionToken} ');
    pushNotificationProvider.onMessageListener();

  }

  //el metodo build es el que construye las vistas de la aplicacion

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Delivery Udemy', //aqui se estabece el titulo de la app
      debugShowCheckedModeBanner: false, //esta linea elimina el text de debug al iniciar la aplicacion
      initialRoute: userSession.id != null ? userSession.roles!.length > 1 ? '/roles' : '/client/home' : '/', //rruta inicia que indica si hay un usuario con sesion abierta diriga al home de lo contrario al login que es la pantalla raiz 1
      getPages: [
        GetPage(name: '/', page: () => LoginPage()), //ruta para abrir el login page al iniciar la aplicacion
        GetPage(name: '/register', page: () => RegisterPage()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/roles', page: () => RolesPage()),
        GetPage(name: '/restaurant/home', page: () => RestaurantHomePage()),
        GetPage(name: '/restaurant/orders/list', page: () => RestaurantOrdersListPage()),
        GetPage(name: '/restaurant/orders/detail', page: () => RestaurantOrdersDetailPage()),
        GetPage(name: '/delivery/orders/list', page: () => DeliveryOrdersListPage()),
        GetPage(name: '/delivery/home', page: () => DeliveryHomePage()),
        GetPage(name: '/delivery/orders/detail', page: () => DeliveryOrdersDetailPage()),
        GetPage(name: '/delivery/orders/map', page: () => DeliveryOrdersMapPage()),
        GetPage(name: '/clients/home', page: () => ClientHomePage()),
        GetPage(name: '/clients/products/list', page: () => ClientProductsListPage()),
        GetPage(name: '/clients/profile/info', page: () => ClientProfileInfoPage()),
        GetPage(name: '/clients/profile/update', page: () => ClientProfileUpdatePage()),
        GetPage(name: '/clients/orders/create', page: () => ClientOrdersCreatePage()),
        GetPage(name: '/clients/orders/detail', page: () => ClientOrdersDetailPage()),
        GetPage(name: '/clients/orders/map', page: () => ClientOrdersMapPage()),
        GetPage(name: '/clients/address/create', page: () => ClientAdressCreatePage()),
        GetPage(name: '/clients/address/list', page: () => ClientAdressListPage()),
        GetPage(name: '/clients/payments/create', page: () => ClientPaymentsCreatePage()),
        GetPage(name: '/clients/payments/installments', page: () => ClientPaymentsIntallmentsPage()),
        GetPage(name: '/clients/payments/status', page: () => ClientPaymentsStatusPage()),
      ],
      theme: ThemeData( //aqui se establece el tema de la aplicacion como colores y demas.
        primaryColor: Colors.amber,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          onBackground: Colors.amber,
          secondary: Colors.amberAccent,
          primary: Colors.amber,
          onPrimary: Colors.amber,
          surface: Colors.amber,
          onSurface: Colors.amber,
          error: Colors.amber,
          onError: Colors.amber,
          onSecondary: Colors.amber,
          background: Colors.amber)
      ),
      navigatorKey: Get.key,
    );
  }
}


