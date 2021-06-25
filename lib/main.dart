import 'package:flutter/material.dart';
import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:proyectofinalsemillero/src/pages/home_page.dart';
import 'package:proyectofinalsemillero/src/pages/messages_page.dart';
import 'package:proyectofinalsemillero/src/pages/form_page.dart';
import 'package:proyectofinalsemillero/src/services/messages_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late BuildContext contextoParaNavegar;

  @override
  void initState() {
    super.initState();
    PushNotificationService.messagesStream.listen((message) {
      if (message.startsWith("[_CONVERSACION_]")) {
        List<String> tmp = message.split("|||");
        ContactoModelo contacto = ContactoModelo.fromJson(tmp[1]);
        _navegarAConversacion(contacto);
      }
      navigatorKey.currentState?.pushNamed('message', arguments: message);
      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    contextoParaNavegar = context;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'messages': (context) => MessagesPage(),
        "editContact": (context) => FormPage(),
      },
      home: HomePage(),
    );
  }

  void _navegarAConversacion(ContactoModelo contacto) {
    //Navigator.pushNamed(contextoParaNavegar, 'messages', arguments: contacto);
  }
}
