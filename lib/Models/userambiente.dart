class UsuarioAmbiente {
  final int idUsuarioAmbiente;
  final int idAmbiente;
  final int idFuncionario;

  UsuarioAmbiente({
    required this.idUsuarioAmbiente,
    required this.idAmbiente,
    required this.idFuncionario,
  });

  factory UsuarioAmbiente.fromJson(Map<String, dynamic> json) {
    return UsuarioAmbiente(
      idUsuarioAmbiente: json['idUsuarioAmbiente'],
      idAmbiente: json['idAmbiente'],
      idFuncionario: json['idFuncionario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuarioAmbiente': idUsuarioAmbiente,
      'idAmbiente': idAmbiente,
      'idFuncionario': idFuncionario,
    };
  }
}
