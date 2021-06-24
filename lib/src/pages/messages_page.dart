import 'dart:async';

import 'package:flutter/material.dart';
import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:proyectofinalsemillero/src/models/conversacion_model.dart';
import 'package:proyectofinalsemillero/src/services/bd_service.dart';
import 'package:proyectofinalsemillero/src/services/http_service.dart';
import 'package:proyectofinalsemillero/src/config/constant_service.dart';
import 'package:proyectofinalsemillero/src/services/messages_services.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final servicioBD = BDService();
  ContactoModelo? contacto;
  final _controllerAddMessagge = TextEditingController();
  final _controladorScroll = ScrollController();

  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PushNotificationService.messagesStream.listen((message) {
      setState(() {
        print(message);
        _irUltimoMensaje();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    contacto = ModalRoute.of(context)!.settings.arguments as ContactoModelo;

    print(contacto!.getUsuarioToken);
    print(contacto!.getUsuarioKey);

    return Scaffold(
      appBar: AppBar(title: Text('En línea ${contacto?.getUsuarioNombre}')),
      body: Column(
        children: [
          Expanded(child: listMessage()),
          Container(
              padding:
                  EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 30),
              child: sectionbuttons()),
        ],
      ),
    );
  }

  sectionbuttons() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 15,
        ),
        Expanded(
          child: TextField(
            controller: _controllerAddMessagge,
            decoration: InputDecoration(
                hintText: "Escribe un Mensaje...",
                hintStyle: TextStyle(color: Colors.black54),
                border: InputBorder.none),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        FloatingActionButton(
          onPressed: () {
            if (_controllerAddMessagge.text.trim() != "") {
              setState(() {
                BDService.bdService.agregarConversacion(ConversacionModelo(
                    usuarioId: contacto!.getUsuarioId,
                    conversacionTipoMensaje: TIPO_MENSAJE_EMISOR,
                    conversacionMensaje: _controllerAddMessagge.text));
                final service = HttpService(
                    to: contacto!.getUsuarioToken,
                    key: contacto!.getUsuarioKey);
                service.sendMessage(_controllerAddMessagge.text);
                _controllerAddMessagge.text = "";
                FocusScope.of(context).requestFocus(new FocusNode());
                _irUltimoMensaje();
              });
            }
          },
          child: Icon(
            Icons.send,
            color: Colors.white,
            size: 18,
          ),
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
      ],
    );
  }

  Widget listMessage() {
    return FutureBuilder<List<ConversacionModelo>>(
        future: BDService.bdService
            .listarConversacionContacto(contactoid: contacto!.getUsuarioId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == true) {
            if (snapshot.data?.length > 0) {
              return ListView.builder(
                controller: _controladorScroll,
                itemCount: snapshot.data?.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  ConversacionModelo mensaje = snapshot.data?[index];
                  return Container(
                    padding: EdgeInsets.only(
                        left: 14, right: 14, top: 10, bottom: 10),
                    child: Align(
                      alignment: (mensaje.conversacionTipoMensaje ==
                              TIPO_MENSAJE_RECEPTOR
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (mensaje.conversacionTipoMensaje ==
                                  TIPO_MENSAJE_RECEPTOR
                              ? Colors.grey.shade200
                              : Colors.blue[200]),
                        ),
                        padding: EdgeInsets.all(16),
                        child: Text(
                          mensaje.conversacionMensaje,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("Sin mensajes"),
              );
            }
          } else {
            return Center(
              child: Text("Sin mensajes"),
            );
          }
        });
  }

  //Realiza el desplazamiento al final de la lista de mensajes
  _irUltimoMensaje() {
    try {
      _controladorScroll.animateTo(_controladorScroll.position.maxScrollExtent,
          duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
    } catch (ex) {
      print(ex);
    }
  }
}
