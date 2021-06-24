import 'package:flutter/material.dart';
import 'package:proyectofinalsemillero/src/models/chatmessage_model.dart';
import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:proyectofinalsemillero/src/models/conversacion_model.dart';
import 'package:proyectofinalsemillero/src/services/bd_service.dart';
import 'package:proyectofinalsemillero/src/services/http_service.dart';

class MessagesPage extends StatefulWidget {
  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  static const String TIPO_MENSAJE_EMISOR = "emisor";
  static const String TIPO_MENSAJE_RECEPTOR = "receptor";
  final servicioBD = BDService();
  ContactoModelo? contacto;
  final _controllerAddMessagge = TextEditingController();
  final _controladorScroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    contacto = ModalRoute.of(context)!.settings.arguments as ContactoModelo;
    return Scaffold(
      appBar: AppBar(title: Text('Messages')),
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
              //TODO: Enviar mensaje al contacto
              setState(() {
                BDService.bdService.agregarConversacion(ConversacionModelo(
                    usuarioId: contacto!.getUsuarioId,
                    conversacionTipoMensaje: TIPO_MENSAJE_EMISOR,
                    conversacionMensaje: _controllerAddMessagge.text));
                final service = HttpService();
                service.sendMessage('Hola test Anthony',
                    "e-DJYqoZR3uXe0GPzYrvV2:APA91bEADMC6TACC10KUm0E_3GEH2F5C3CPXrmk90IMJeYndqrLC3wAs3RCQ2GRhk1KXwPe_Dya4dYvsoY2au0ib4BiLkM46pdJrNle_0547iNwpi5H5aX9JmMDKeN7kaPvNGZhY1GU-");
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
