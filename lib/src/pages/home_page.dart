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
  
  List<Map<String, dynamic>> contacts = [
    {'id': 1, 'name': 'Pedro', 'lastName': "Perez"},
    {'id': 2, 'name': 'Jose', 'lastName': "Rodriguez"},
    {'id': 3, 'name': 'John', 'lastName': "Doe"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
    {'id': 4, 'name': 'Bill', 'lastName': "Gates"},
  ];

  @override
  Widget build(BuildContext context) {
    BDService.bdService.baseDatos;
    return Scaffold(
      appBar: AppBar(title: Text('contacts')),
      body: Column(
        children: [Expanded(child: listMessage()), buttonScanner()],
      ),
    );
  }

  Widget listMessage() {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return ListTile(
          title:
              Text(contacts[index]['name'] + " " + contacts[index]['lastName']),
          leading: Icon(Icons.ac_unit_outlined),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.pushNamed(context, 'messages');
          },
        );
      },
    );
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
      Map mapScan =  jsonDecode(barcodeScanRes);
      ContactoModelo contacto =  ContactoModelo(
        usuarioToken:mapScan['token'],
        usuarioKey:mapScan['key'],
        usuarioNombre:mapScan['usuario'],
        usuarioUrlAvatar:mapScan['url_avatar'],
      );
      BDService.bdService.insertarContacto(contacto);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }
}
