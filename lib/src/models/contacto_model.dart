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
}
