
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:proyectofinalsemillero/src/services/bd_service.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _usuarioToken = TextEditingController();
  final _usuarioKey = TextEditingController();
  final _ctrlNames = TextEditingController();
  final _ctrlLastNames = TextEditingController();
  List<ContactoModelo> _contactos = <ContactoModelo>[];


  @override
  void initState() {
    super.initState();
    //_getUsers();
  }

  @override
  Widget build(BuildContext context) {
     ContactoModelo? contacto;
    // BDService.dbPublic.instanceBD;
    // final userBlocValidator = ProviderBloc.of(context);

    // ignore: avoid_unnecessary_containers
     contacto = ModalRoute.of(context)!.settings.arguments as ContactoModelo;
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              TextFormField(
                controller: _usuarioToken,
                decoration: const InputDecoration(
                  labelText: 'Usuario Token',
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el token';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usuarioKey,
                decoration: const InputDecoration(
                  labelText: 'Usuario Key',
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la key';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () {
                  // if (_formKey.currentState.validate()) {
                  //   _ingresar();
                  // } else {}
                },
                child: const Text("Guardar"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
        // Expanded(
        //   child: 
        //   _listUsersCards(),
        // ),
        // ignore: avoid_unnecessary_containers
        Container(
          margin: const EdgeInsets.only(
            bottom: 15.0,
          ),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  elevation: 5.0,
                ),
                onPressed: () => {},
                child: SizedBox(
                  width: 120.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Icon(Icons.delete),
                      const Text("Eliminar Datos")
                    ],
                  ),
                ),
              ),
             ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start barcode scan')),
            ],
          ),
        )
      ],
    );
  }

    Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
      Map valueMap = json.decode(barcodeScanRes);
      print(valueMap['users']);
      List listUsers = valueMap['users'] as List;
      for (var item in listUsers) {

        // UserModel user =  UserModel(names: item['names'],lastNames: item['lastNames'] );

        // final result =  await UserService.dbPublic.insertUser(user);
      }
      setState(() {
        
      });
      
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }


  }



  // Widget _listUsersCards() {
  //   return FutureBuilder<List<UserModel>>(
  //     future: _getUsers(),
  //     builder: (
  //       BuildContext context,
  //       AsyncSnapshot<List<dynamic>> snapshot,
  //     ) {
  //       if (snapshot.hasData) {
  //         if (snapshot.data.isNotEmpty) {
  //           return ListView(
  //             children: _listaUsers(snapshot.data as dynamic, context),
  //           );
  //         } else {
  //           // ignore: avoid_unnecessary_containers
  //           return Container(
  //               child: const Text("No hay registros para mostrar"));
  //         }
  //       } else {
  //         // ignore: avoid_unnecessary_containers
  //         return Container(child: const Text("No hay registros para mostrar"));
  //       }
  //     },
  //   );
  // }



  // void _ingresar() async {
  //   try {
  //     setState(() {
  //       UserModel user = UserModel(
  //         names: _ctrlNames.text,
  //         lastNames: _ctrlLastNames.text,
  //       );

  //       UserService.dbPublic.insertUser(user);
  //       _formKey.currentState.reset();
  //       _getUsers();
  //     });
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e);
  //   }
  // }




}