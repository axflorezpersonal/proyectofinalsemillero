import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
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
    print('Desde onBackground');
    print(message.data);
     FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 0.5, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
    if (message.data["token_from"].toString().isNotEmpty == true) {
      _enviarMensaje(message.data["token_from"], message.data['message'],
          message.data['key_from']);
    }
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('Desde onMessageHandler');
     FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 0.5, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
    print(message.data);
    if (message.data["token_from"].toString().isNotEmpty == true) {
      _enviarMensaje(message.data["token_from"], message.data['message'],
          message.data['key_from']);
    }
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('Desde onMessageOpenApp');
     FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 0.5, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );
    print(message.data);
    /*if (message.data["token_from"].toString().isNotEmpty == true) {
      _enviarMensaje(message.data["token_from"], message.data['message']);
    }*/
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    await requestPermission();

    token = await FirebaseMessaging.instance.getToken();
    print('Token de la aplicacion : $token');

    TOKEN_APP = token!;

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
    FlutterRingtonePlayer.play(
      android: AndroidSounds.notification,
      ios: IosSounds.glass,
      looping: false, // Android only - API >= 28
      volume: 0.5, // Android only - API >= 28
      asAlarm: false, // Android only - all APIs
    );

    print('User push notification status ${settings.authorizationStatus}');
  }

  static closeStreams() {
    _messageStream.close();
  }

  static _enviarMensaje(String token, String mensaje, String keyFrom) async {
    ContactoModelo contactoRemitente =
        await BDService.bdService.buscarContactoPorToken(token, keyFrom);
    print(contactoRemitente);

    await BDService.bdService.agregarConversacion(ConversacionModelo(
        usuarioId: contactoRemitente.getUsuarioId,
        conversacionTipoMensaje: TIPO_MENSAJE_RECEPTOR,
        conversacionMensaje: mensaje));
    _messageStream.add(mensaje);
  }
}
