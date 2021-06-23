import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:proyectofinalsemillero/src/models/contacto_model.dart';
import 'package:proyectofinalsemillero/src/models/conversacion_model.dart';
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

    print("Desde abrir: $rutaBD");

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

  /* Gestionar contactos */
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

  Future<List<ContactoModelo>> listarContactos() async {
    final bd = await baseDatos;
    List<ContactoModelo> listaContactos = [];
    List resultado = await bd!.rawQuery("SELECT * FROM contactos");
    print("lala: $resultado");
    resultado.forEach((contacto) {
      ContactoModelo tmpPersona = ContactoModelo(
          usuarioId: contacto["contacto_id"],
          usuarioToken: contacto["contacto_token"],
          usuarioKey: contacto["contacto_key"],
          usuarioNombre: contacto["contacto_nombre"],
          usuarioUrlAvatar: contacto["contacto_url_avatar"]);
      listaContactos.add(tmpPersona);
    });
    return listaContactos;
  }

  borrarTodosContactos() async {
    final db = await baseDatos;
    final res = db!.rawDelete("DELETE FROM contactos");
  }

  borrarContacto({required int id}) async {
    final db = await baseDatos;
    db!.rawDelete("DELETE FROM contactos WHERE contacto_id = $id");
  }

  /* Gestionar conversaciones */

  agregarConversacion(ConversacionModelo conversacion) async {
    final bd = await baseDatos;
    await bd!.insert("conversaciones", {
      "contacto_id": conversacion.usuarioId,
      "conversacion_tipo_mensaje": conversacion.conversacionTipoMensaje,
      "conversacion_mensaje": conversacion.conversacionMensaje
    });
  }

  Future<List<ConversacionModelo>> listarConversacionContacto(
      {required int contactoid}) async {
    final bd = await baseDatos;
    List<ConversacionModelo> listaConversaciones = [];
    List resultado = await bd!.rawQuery(
        "SELECT * FROM conversaciones WHERE contacto_id = $contactoid");
    print("lala: $resultado");
    resultado.forEach((conversacion) {
      ConversacionModelo tmpConversacion = ConversacionModelo(
          conversacionId: conversacion["conversacion_id"],
          usuarioId: conversacion["contacto_id"],
          conversacionTipoMensaje: conversacion["conversacion_tipo_mensaje"],
          conversacionMensaje: conversacion["conversacion_mensaje"]);
      listaConversaciones.add(tmpConversacion);
    });
    return listaConversaciones;
  }
}
