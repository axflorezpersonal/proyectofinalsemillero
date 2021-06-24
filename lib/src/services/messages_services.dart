import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:proyectofinalsemillero/src/models/conversacion_model.dart';
import 'package:proyectofinalsemillero/src/services/bd_service.dart';
import 'package:proyectofinalsemillero/src/config/constant_service.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backgroundHandler(RemoteMessage message) async {
    print('onBackground');
    print(message.data);
    _messageStream.add(message.data['clave'] ?? 'No hay datos');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('onMessage');
    print(message.data);
    if (message.data["from"] != null) {
      ContactoModelo contactoRemitente =
          await BDService.bdService.buscarContactoPorToken(message.data["to"]);

      print(contactoRemitente);

      await BDService.bdService.agregarConversacion(ConversacionModelo(
          usuarioId: contactoRemitente.getUsuarioId,
          conversacionTipoMensaje: TIPO_MENSAJE_RECEPTOR,
          conversacionMensaje: message.data['message']));
    }

    _messageStream.add(message.data['message'] ?? 'No hay datos');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('onMessageOpenApp');
    print(message.data);
    _messageStream.add(message.data['clave'] ?? 'No hay datos');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    print('Token de la aplicacion : $token');

    //TOKEN_APP = token!;

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }
}
