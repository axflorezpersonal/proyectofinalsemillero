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
  final _usuarioNombre = TextEditingController();
  final _usuarioUrlAvatar = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ContactoModelo? contacto;
    contacto = ModalRoute.of(context)!.settings.arguments as ContactoModelo;
    _usuarioToken.text=contacto.getUsuarioToken;
    _usuarioKey.text=contacto.getUsuarioKey;
    _usuarioNombre.text=contacto.getUsuarioNombre;
    _usuarioUrlAvatar.text=contacto.getUsuarioUrlAvatar;
    return Scaffold(
      appBar: AppBar(title: Text('Editar contacto')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  TextFormField(
                    controller: _usuarioToken,
                    enabled: false,
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
                    enabled: false,
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
                   
                  TextFormField(
                    controller: _usuarioNombre,
                    decoration: const InputDecoration(
                      labelText: 'Usuario Nombre',
                      labelStyle: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el nombre del usuarip';
                      }
                      return null;
                    },
                  ),
                   TextFormField(
                    controller: _usuarioUrlAvatar,
                    decoration: const InputDecoration(
                      labelText: 'Usuario url Avatar',
                      labelStyle: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa la url del avatar del usuario';
                      }
                      return null;
                    },
                  ),
                   
                  
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        contacto?.setUsuarioNombre=_usuarioNombre.text;
                        contacto?.setUsuarioUrlAvatar=_usuarioNombre.text;
                         BDService.bdService.editarContacto(contacto!);
                      } else {}
                    },
                    child: const Text("Guardar"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.teal[800],
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
          ),
        ],
      ),
    );
  }
}
