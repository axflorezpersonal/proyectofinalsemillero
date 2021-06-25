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
    String directorio = await getDatabasesPath();
    final rutaBD = join(directorio, "dbChat.db");
    return await openDatabase(rutaBD, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''CREATE TABLE IF NOT EXISTS contactos (
            contacto_id INTEGER PRIMARY KEY AUTOINCREMENT,
            contacto_token TEXT,
            contacto_key TEXT,
            contacto_nombre TEXT,
            contacto_url_avatar TEXT
          );
        ''');
      return db.execute('''CREATE TABLE IF NOT EXISTS conversaciones (
          conversacion_id INTEGER PRIMARY KEY AUTOINCREMENT,
          contacto_id INTEGER,
          conversacion_tipo_mensaje TEXT,
          conversacion_mensaje TEXT,
          FOREIGN KEY (contacto_id) REFERENCES contactos (contacto_id) ON DELETE NO ACTION ON UPDATE NO ACTION
          );
        ''');
    });
  }

  /* Gestionar contactos */
  Future<ContactoModelo> insertarContacto(ContactoModelo nuevoContacto) async {
    final bd = await baseDatos;
    final idInsertado = await bd!.insert("contactos", {
      "contacto_token": nuevoContacto.usuarioToken,
      "contacto_key": nuevoContacto.usuarioKey,
      "contacto_nombre": nuevoContacto.usuarioNombre,
      "contacto_url_avatar": nuevoContacto.usuarioUrlAvatar
    });
    nuevoContacto.setUsiarioId = idInsertado;
    return nuevoContacto;
  }
     insertarContactoPruebaAnaCarol() async {
    final bd = await baseDatos;
    final idInsertado = await bd!.insert("contactos", {
      "contacto_token":'fVKv9hYCRWuChQlox-f97n:APA91bEN3BFUPHtIDw0KpJoN8bcER6Jw3TIMyv_VX7e6CLsGimvh8lbHWtRlA0IS2T9B8QHdOErOMtsdylaVfKQLn353ajuFp4U4LnR2ENx4JzipwYO1oAHRPryBFy4R8Ws6cok7LEHf',
      "contacto_key": 'AAAA4StsKSY:APA91bEhMvUiW2oMwkk3YlC28KntUkEn5R54OHrDKb_Zm3GwI3e7I5anWubvbG5X-Ybc1CuZWIHOcK2P8bp5hcmR6uxHmW-WyOpJHdMI97NQVUYurMTwRkQ2VOx2utq94Z8ph5aSOtwM',
      "contacto_nombre": 'Oscar Fernando Espinosa Rocha',
      "contacto_url_avatar": 'https://www.profamedica.com/wp-content/uploads/2018/01/avatar-hombre.png'
    });

    print("idInsertado: $idInsertado");
  }

  editarContacto(ContactoModelo editarContacto) async {
    final bd = await baseDatos;
    final idActualizado = await bd!.rawUpdate(
        "UPDATE contactos SET contacto_token = '${editarContacto.usuarioToken}', contacto_key = '${editarContacto.usuarioKey}',contacto_nombre= '${editarContacto.usuarioNombre}',contacto_url_avatar='${editarContacto.usuarioUrlAvatar}' WHERE contacto_id='${editarContacto.usuarioId}'");
    return editarContacto;
  }

  Future<List<ContactoModelo>> listarContactos() async {
    final bd = await baseDatos;
    List<ContactoModelo> listaContactos = [];
    List resultado = await bd!.rawQuery("SELECT * FROM contactos");
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
    db!.rawDelete("DELETE FROM contactos");
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

  Future<ContactoModelo> buscarContactoPorToken(
      String token, String keyFrom) async {
    final bd = await baseDatos;
    late ContactoModelo contactoEncontrado;
    List resultado = await bd!.rawQuery(
        "SELECT * FROM contactos WHERE contacto_token = '$token' LIMIT 1");
    if (resultado.length == 0) {
      ContactoModelo usuarioDesconocido = ContactoModelo(
          usuarioToken: token,
          usuarioKey: keyFrom,
          usuarioNombre: 'Usuario desconocido',
          usuarioUrlAvatar: '');
      return bdService.insertarContacto(usuarioDesconocido);
    }
    resultado.forEach((contacto) {
      contactoEncontrado = ContactoModelo(
          usuarioId: contacto["contacto_id"],
          usuarioToken: contacto["contacto_token"],
          usuarioKey: contacto["contacto_key"],
          usuarioNombre: contacto["contacto_nombre"],
          usuarioUrlAvatar: contacto["contacto_url_avatar"]);
    });
    return contactoEncontrado;
  }

  Future<List<ConversacionModelo>> listarConversacionContacto(
      {required int contactoid}) async {
    final bd = await baseDatos;
    List<ConversacionModelo> listaConversaciones = [];
    List resultado = await bd!.rawQuery(
        "SELECT * FROM conversaciones WHERE contacto_id = $contactoid");
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
