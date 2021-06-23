import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BDService {
  static Database? _bd;

  static final BDService bdService = BDService();
  BDService();

  Future<Database?> get baseDatos async {
    if (_bd == null) {
      return abrirBD();
    } else {
      return _bd;
    }
  }

  Future<Database?> abrirBD() async {
    Directory directorio = await getApplicationDocumentsDirectory();
    final rutaBD = join(directorio.path, "dbChat.db");

    //TODO: Quitar esto
    print("Desde abrir BD: $rutaBD");

    return await openDatabase(rutaBD, version: 1,
        onCreate: (Database db, int version) async {
      return await db.execute('''
          CREATE TABLE IF NOT EXISTS contactos (
            contacto_id INTEGER PRIMARY KEY AUTOINCREMENT,
            contacto_token TEXT,
            contacto_key TEXT,
            contacto_nombre TEXT,
            contacto_url_avatar TEXT
          );

        CREATE TABLE IF NOT EXISTS conversaciones (
          conversacion_id INTEGER PRIMARY KEY AUTOINCREMENT,
          contacto_id INTEGER,
          conversacion_tipo_mensaje INTEGER,
          conversacion_mensaje TEXT,
          FOREIGN KEY (contacto_id) REFERENCES contactos (contacto_id) ON DELETE NO ACTION ON UPDATE NO ACTION
          );
        ''');
    });
  }

  insertarContacto(ContactoModelo nuevoContacto) async {
    final bd = await baseDatos;
    final idInsertado = await bd!.insert("contactos", {
      "contacto_token": nuevoContacto.usuarioToken,
      "contacto_key": nuevoContacto.usuarioKey,
      "contacto_nombre": nuevoContacto.usuarioNombre,
      "contacto_url_avatar": nuevoContacto.usuarioUrlAvatar
    });

    print("idInsertado: $idInsertado");
  }
}
