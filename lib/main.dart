import 'package:flutter/material.dart';
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


  late BuildContext contextoParaNavegar;

  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    contextoParaNavegar = context;
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, primaryColor: Colors.teal[800],accentColor: Colors.greenAccent),
      routes: {
        'messages': (context) => MessagesPage(),
        "editContact": (context) => FormPage(),
      },
      home: HomePage(),
    );
  }

}
