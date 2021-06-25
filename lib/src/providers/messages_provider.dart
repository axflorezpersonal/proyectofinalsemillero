import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:proyectofinalsemillero/src/config/constant_service.dart';
import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:proyectofinalsemillero/src/models/conversacion_model.dart';
import 'package:proyectofinalsemillero/src/services/bd_service.dart';

class MessagesProvider extends ChangeNotifier {
  void agregarMensaje(RemoteMessage message) async {
    ContactoModelo contactoRemitente = await BDService.bdService
        .buscarContactoPorToken(message.data["token_from"],message.data["key_from"]);
    await BDService.bdService.agregarConversacion(ConversacionModelo(
        usuarioId: contactoRemitente.getUsuarioId,
        conversacionTipoMensaje: TIPO_MENSAJE_RECEPTOR,
        conversacionMensaje: message.data['message']));

    notifyListeners();
  }
}
