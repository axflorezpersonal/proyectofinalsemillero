import 'package:flutter/material.dart';
import 'package:proyectofinalsemillero/src/pages/home_page.dart';
import 'package:proyectofinalsemillero/src/pages/messages_page.dart';
import 'package:proyectofinalsemillero/src/services/messages_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushNotificationService.initializeApp();

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatefulWidget {
    @override
  _MyAppState createState() => _MyAppState();
  }

  class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    // Context!
    PushNotificationService.messagesStream.listen((message) {
      navigatorKey.currentState?.pushNamed('message', arguments: message);
      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        'messages':(context) => MessagesPage()
      },
      home: HomePage(),
    );
  }
}

