class Funcionario {
   int idFunc;
   String nomeUsuario;
   String email;
   String senha;
   String cpf;
   bool adm;

   Funcionario({required this.idFunc, required this.nomeUsuario, required this.email, required this.senha, required this.cpf, required this.adm});

 Funcionario copyWith({
    int? idFunc,
    String? nomeUsuario,
    String? email,
    String? senha,
    String? cpf,
    bool? adm,
  }) {
    return Funcionario(
      idFunc: idFunc ?? this.idFunc,
      nomeUsuario: nomeUsuario ?? this.nomeUsuario,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      cpf: cpf ?? this.cpf,
      adm: adm ?? this.adm,
    );
  }

  Map<String, dynamic> toJson () {
    return {
      "idFuncionario": idFunc,
      "nome_usuario": nomeUsuario,
      "email": email,
      "password": senha,
      "cpf": cpf,
      "type_adm": true
    };
  }

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario (
      idFunc: json['idFuncionario'],
      nomeUsuario: json['nome_usuario'],
      email: json['email'],
      senha: json['password'],
      cpf: json['cpf'] ?? "Sem Cpf",
      adm: json['type_adm'],
    );
  }

  get idAmbiente => null;
}