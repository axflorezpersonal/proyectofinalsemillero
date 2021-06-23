class ConversacionModelo {
  int conversacionId;
  int usuarioId;
  int conversacionTipoMensaje;
  String conversacionMensaje;
  ConversacionModelo({
    this.conversacionId = 0,
    required this.usuarioId,
    required this.conversacionTipoMensaje,
    required this.conversacionMensaje,
  });
}
