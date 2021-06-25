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
  set setUsiarioId(int id)=>this.usuarioId=id;
}
