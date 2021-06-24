class ConversacionModelo {
  int conversacionId;
  int usuarioId;
  String conversacionTipoMensaje; //emisor o receptor
  String conversacionMensaje;
  ConversacionModelo({
    this.conversacionId = 0,
    required this.usuarioId,
    required this.conversacionTipoMensaje,
    required this.conversacionMensaje,
  });
}
