class Temperatura {
  final int idTemperatura;
  final double temperatura;
  final String horarioTemp;
  final int idAmbiente;

  Temperatura({
    required this.idTemperatura,
    required this.temperatura,
    required this.horarioTemp,
    required this.idAmbiente,
  });

  factory Temperatura.fromJson(Map<String, dynamic> json) {
    return Temperatura(
      idTemperatura: json['idTemperatura'],
      temperatura: json['temperatura'],
      horarioTemp: json['horarioTemp'],
      idAmbiente: json['idAmbiente'],
    );
  }
}