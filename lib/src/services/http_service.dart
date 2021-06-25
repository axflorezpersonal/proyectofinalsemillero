import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyectofinalsemillero/src/config/constant_service.dart';

class HttpService {
  String to; //token de la aplicación
  String key; //Key de la aplicación

  HttpService({required this.to, required this.key});

  Future<Map<dynamic, dynamic>> sendMessage(String message) async {
    final url = 'https://fcm.googleapis.com/fcm/send';
    final datos = {
      "notification": {
        "body": "Toca aquí para verlo",
        "title": "Tienes un nuevo mensaje!"
      },
      
      "apns":{
        "payload":{
            "aps":{
              "sound":"default"
            }
        }
      },
      "priority": "high",
      "data": {"message": message, "token_from": TOKEN_APP, 'key_from':keyServer},
      "to": to
    };
    print(keyServer);
    final respuesta = await http.post(Uri.parse(url),
        body: json.encode(datos),
        headers: {
          'Authorization': "key=" + key,
          'content-type': 'application/json'
        });

    Map<String, dynamic> resDatos = json.decode(respuesta.body);

    if (respuesta.statusCode == 200) {
      return resDatos;
    } else {
      print(resDatos);
      return throw Exception(resDatos['error_description']);
    }
  }
}
