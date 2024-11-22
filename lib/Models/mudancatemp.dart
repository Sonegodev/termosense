class MudancaTemperatura {
  final int idMudancaTemp;
  final int temperaturaAlterada;
  final int temperatura;
  final int idAmbiente;
  final int idFuncionario;
  final DateTime horarioMudanca;

  MudancaTemperatura({
    required this.idMudancaTemp,
    required this.temperaturaAlterada,
    required this.temperatura,
    required this.idAmbiente,
    required this.idFuncionario,
    required this.horarioMudanca,
  });

  factory MudancaTemperatura.fromJson(Map<String, dynamic> json) {
    return MudancaTemperatura(
      idMudancaTemp: json['idMudancaTemp'],
      temperaturaAlterada: json['temperatura_alterada'],
      temperatura: json['temperatura'],
      idAmbiente: json['idAmbiente'],
      idFuncionario: json['idFuncionario'],
      horarioMudanca: DateTime.parse(json['horarioMudanca']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMudancaTemp': idMudancaTemp,
      'temperatura_alterada': temperaturaAlterada,
      'temperatura': temperatura,
      'idAmbiente': idAmbiente,
      'idFuncionario': idFuncionario,
      'horarioMudanca': horarioMudanca.toIso8601String(),
    };
  }
}
