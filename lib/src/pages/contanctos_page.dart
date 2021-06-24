import 'package:flutter/material.dart';

class ContactosPage extends StatefulWidget {
 // ContactosPage({Key key}) : super(key: key);

  @override
  _ContactosPageState createState() => _ContactosPageState();
}

class _ContactosPageState extends State<ContactosPage> {

  final _listaContactos = ["Ana", "Natalia", "Anthony", "Jerez", "Tejada", "Oscar","Luis", "Miguel"];
 
 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contactos'),
      ),
      body: _contactos(),
     
    );
  }

  Widget _contactos() {

    /*return ListView(
      children: _items(),
    );*/

    return ListView.builder(
      itemCount: _listaContactos.length,
      itemBuilder: (context, int index){

        return ListTile(
          title: Text(_listaContactos[index]),
          leading: _avatar(),
          trailing: Icon(Icons.keyboard_arrow_right),
          subtitle: Text("311654987"),
          onTap: (){

            Navigator.pushNamed(context, 'detalle_contacto',arguments:_listaContactos[index]);

          },
        );

      },
    );

  }
   Widget _componentes() {

    /*return ListView(
      children: _items(),
    );*/

    return ListView.builder(
      itemCount: _listaContactos.length,
      itemBuilder: (context, int index){

        return ListTile(
          title: Text(_listaContactos[index]),
          leading: _avatar(),
          trailing: Icon(Icons.keyboard_arrow_right),
          subtitle: Text("311654987"),
          onTap: (){

            Navigator.pushNamed(context, 'detalle_contacto',arguments:_listaContactos[index]);

          },
        );

      },
    );

  }

  List<Widget> _items() {

    //List<Widget> listaContactos = [];

    /*_listaContactos.forEach((element) {
      
      final listtile = ListTile(
        title: Text(element),
        leading: Icon(Icons.account_box_rounded),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: (){

          //Navigator.pushNamed(context, 'contactos');

        },
      );

      listaContactos.add(listtile);

    });*/

    return _listaContactos.map((e) {
      
      return Column(
        children: [

          ListTile(
            title: Text(e),
            leading: _avatar(),
            trailing: Icon(Icons.keyboard_arrow_right),
            subtitle: Text("311654987"),
            onTap: (){

              Navigator.pushNamed(context, 'detalle_contacto');

            },
          ),
          Divider(),
        ],
      );

      //listaContactos.add(listtile);
      
    }).toList();

  }

  Widget _avatar() {

    return CircleAvatar(
      radius: 30.0,
      backgroundImage: NetworkImage('https://e00-marca.uecdn.es/assets/multimedia/imagenes/2020/06/04/15912219730543.jpg'),
    );

  }
 
}