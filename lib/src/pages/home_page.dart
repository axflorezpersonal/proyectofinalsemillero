import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Map<String,dynamic>> contacts = [
    {'id':1,'name':'Pedro', 'lastName':"Perez"},
    {'id':2,'name':'Jose', 'lastName':"Rodriguez"},
    {'id':3,'name':'John', 'lastName':"Doe"},
    {'id':4,'name':'Bill', 'lastName':"Gates"},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('contacts')),
      body: Column(
        children: [
          Expanded(child: listMessage()),
        ],
      ),
    );
  }


   Widget listMessage() {
    return ListView.builder(
      itemCount: contacts.length,
   
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(contacts[index]['name']+" "+contacts[index]['lastName']),
          leading:Icon(Icons.ac_unit_outlined),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: (){
            Navigator.pushNamed(context, 'messages');
          },
        );
      },
    );
  }
}