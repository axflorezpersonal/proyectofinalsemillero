import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:proyectofinalsemillero/src/services/bd_service.dart';


class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final servicioBD = BDService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('contacts')),
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
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  final contacto = snapshot.data?[index];
                  print("Contacto $index: ${contacto.toString()}");
                  return ListTile(
                    title: Text(contacto.usuarioNombre),
                    leading: Icon(Icons.ac_unit_outlined),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.pushNamed(context, 'messages',
                          arguments: {contacto.contactoId});
                    },
                  );
                },
              );
            } else {
              return Container(child: Text("No hay contactos"));
            }
          } else {
            return Container(child: Text("No hay contactos"));
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
}
