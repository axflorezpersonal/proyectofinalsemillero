import 'dart:convert';

class ContactoModelo {
  int usuarioId;
  String usuarioToken;
  String usuarioKey;
  String usuarioNombre;
  String usuarioUrlAvatar;
  ContactoModelo(
      {this.usuarioId = 0,
      required this.usuarioToken,
      required this.usuarioKey,
      required this.usuarioNombre,
      required this.usuarioUrlAvatar});

  int get getUsuarioId => this.usuarioId;
  String get getUsuarioToken => this.usuarioToken;
  String get getUsuarioKey => this.usuarioKey;
  String get getUsuarioNombre => this.usuarioNombre;
  String get getUsuarioUrlAvatar => this.usuarioUrlAvatar;
  set setUsiarioId(int id) => this.usuarioId = id;

  String get toJSon =>
      '{"contacto_id": "${this.usuarioId}","contacto_token": "${this.usuarioToken}","contacto_key": "${this.usuarioKey}","contacto_nombre": "${this.usuarioNombre}","contacto_url_avatar": "${this.usuarioUrlAvatar}"}';

  static ContactoModelo fromJson(String json) {
    Map<String, dynamic> obJson = jsonDecode(json);
    return ContactoModelo(
        usuarioId: int.parse(obJson["contacto_id"]),
        usuarioToken: obJson["contacto_token"],
        usuarioKey: obJson["contacto_key"],
        usuarioNombre: obJson["contacto_nombre"],
        usuarioUrlAvatar: obJson["contacto_url_avatar"]);
  }
}
