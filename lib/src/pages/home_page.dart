import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:proyectofinalsemillero/src/services/bd_service.dart';
import 'package:proyectofinalsemillero/src/services/messages_services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final servicioBD = BDService();

  @override
  void initState() {
    super.initState();
    PushNotificationService.contactosStream.listen((jsonContacto) {
      if (jsonContacto.isNotEmpty) {
        ContactoModelo contactoQueEscribe =
            ContactoModelo.fromJson(jsonContacto);
        Navigator.pushNamed(context, 'messages', arguments: contactoQueEscribe);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contactos')),
      body: Column(
        children: [Expanded(child: listMessage()), buttonScanner()],
      ),
    );
  }

  Widget listMessage() {
    return FutureBuilder<List<ContactoModelo>>(
        future: BDService.bdService.listarContactos(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == true) {
            if (snapshot.data?.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.only(top: 30.0),
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final contacto = snapshot.data?[index];
                  return ListTile(
                    title: Text(contacto.usuarioNombre),
                    leading: _verImg(contacto),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                     
                      Navigator.pushNamed(context, 'messages',
                          arguments: contacto);
                    },
                  );
                },
              );
            } else {
              return Center(child: Text("No hay contactos"));
            }
          } else {
            return Center(child: Text("No hay contactos"));
          }
        });
  }

  Widget buttonScanner() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        child: IconButton(
            color: Colors.blue,
            onPressed: () {
              scanQR();
            },
            icon: Icon(Icons.qr_code_scanner)),
      )
    ]);
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancelar', true, ScanMode.QR);
      Map mapScan = jsonDecode(barcodeScanRes);
      ContactoModelo contacto = ContactoModelo(
        usuarioToken: mapScan['token'],
        usuarioKey: mapScan['key'],
        usuarioNombre: mapScan['usuario'],
        usuarioUrlAvatar: mapScan['url_avatar'],
      );
      setState(() {
        BDService.bdService.insertarContacto(contacto);
      });
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }

  Widget _verImg(ContactoModelo contacto) {
    if (contacto.usuarioUrlAvatar == '') {
      return Container(
        width: 50.0,
        child: InkWell(
          child: CircleAvatar(
            radius: 100.0,
            backgroundImage: NetworkImage(
                'https://c0.klipartz.com/pngpicture/730/348/gratis-png-iconos-de-computadora-cargar-icono-de-carga-thumbnail.png'),
          ),
        ),
      );
    } else {
      return Container(
        width: 50.0,
        child: CircleAvatar(
          radius: 100.0,
          backgroundImage: NetworkImage('${contacto.usuarioUrlAvatar}'),
        ),
      );
    }
  }
}
