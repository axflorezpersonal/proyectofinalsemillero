import 'package:flutter/material.dart';
import 'package:proyectofinalsemillero/src/models/chatmessage_model.dart';
import 'package:proyectofinalsemillero/src/services/http_service.dart';

class MessagesPage extends StatefulWidget {
  MessagesPage({Key? key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}



class _MessagesPageState extends State<MessagesPage> {
  final _controllerAddMessagge = TextEditingController();
  List<ChatMessage> messages = [
    // ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    // ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    // ChatMessage(
    //     messageContent: "Hey Kriss, I am doing fine dude. wbu?",
    //     messageType: "sender"),
    // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    // ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
    // ChatMessage(
    //     messageContent: "Is there any thing wrong?", messageType: "sender"),
  ];

  @override
  Widget build(BuildContext context) {
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
            print(_controllerAddMessagge.text);

            setState(() {
              ChatMessage chatMessage = ChatMessage(
                  messageContent: _controllerAddMessagge.text,
                  messageType: 'sender');
              messages.add(chatMessage);

              final service = HttpService();
              service.sendMessage('Hola test Anthony', "e-DJYqoZR3uXe0GPzYrvV2:APA91bEADMC6TACC10KUm0E_3GEH2F5C3CPXrmk90IMJeYndqrLC3wAs3RCQ2GRhk1KXwPe_Dya4dYvsoY2au0ib4BiLkM46pdJrNle_0547iNwpi5H5aX9JmMDKeN7kaPvNGZhY1GU-");
              _controllerAddMessagge.text = '';
            });

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
    return ListView.builder(
      itemCount: messages.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      // physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: (messages[index].messageType == "receiver"
                ? Alignment.topLeft
                : Alignment.topRight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (messages[index].messageType == "receiver"
                    ? Colors.grey.shade200
                    : Colors.blue[200]),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
                messages[index].messageContent,
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        );
      },
    );
  }
}
