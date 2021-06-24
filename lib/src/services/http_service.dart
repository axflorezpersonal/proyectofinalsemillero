import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyectofinalsemillero/src/config/constant_service.dart';

class HttpService {
  Future<Map<dynamic, dynamic>> sendMessage(String message, String to ) async {
    final url = 'https://fcm.googleapis.com/fcm/send';
    final datos = {
      "notification": {"body": "Texto del push", "title": "Titulo pruebas"},
      "priority": "high",
      "data": {"clave":"test"},
      "to":to
          
    };

    final respuesta = await http.post(Uri.parse(url),
        body: json.encode(datos) , headers: 
        {
          'Authorization': 'key=AAAApbz-qcY:APA91bFhrdi8ZDFQGqjY7-lW8F5s0krlFHKmsMN22tvKHvE6uLgVpNNmsW--nwyKGp7IisjvmGkO8NCm47MLM_RLZsCzll3GeCZz5G1B_DsyrLE5Hkn5zKu3TD6NQgl4SeI-FqNrvzcb',
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
