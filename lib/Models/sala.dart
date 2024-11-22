class Ambiente {
  int idAmbiente;
  String nomeAmbiente;

  Ambiente({required this.idAmbiente, required this.nomeAmbiente});

  Ambiente copyWith({
    int? idAmbiente,
    String? nomeAmbiente,
  }) {
    return Ambiente(
      idAmbiente: idAmbiente ?? this.idAmbiente,
      nomeAmbiente: nomeAmbiente ?? this.nomeAmbiente,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idAmbiente': idAmbiente,
      'nomeAmbiente': nomeAmbiente,
    };
  }

  factory Ambiente.fromJson(Map<String, dynamic> json) {
    return Ambiente(
      idAmbiente: json['idAmbiente'],
      nomeAmbiente: json['nomeAmbiente'],
    );
  }
  
}