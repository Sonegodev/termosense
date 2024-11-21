class UsuarioAmbiente {
  
  final int idAmbiente;
  final int idFuncionario;

  UsuarioAmbiente({

    required this.idAmbiente,
    required this.idFuncionario,
  });

  factory UsuarioAmbiente.fromJson(Map<String, dynamic> json) {
    return UsuarioAmbiente(

      idAmbiente: json['idAmbiente'],
      idFuncionario: json['idFuncionario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'idAmbiente': idAmbiente,
      'idFuncionario': idFuncionario,
    };
  }
}
