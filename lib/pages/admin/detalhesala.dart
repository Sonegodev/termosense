import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/DataUser/usersp.dart';
import 'package:termosense/Provider/adm/funcprovider.dart';
import 'package:termosense/Provider/adm/tempprovider.dart';
import 'package:termosense/Provider/adm/userambprovider.dart';
import 'package:termosense/btn/button.dart';
import 'package:termosense/style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetalhesSala extends StatefulWidget {
  final int idAmbiente;
  final String? nomeAmbiente;

  const DetalhesSala({super.key, required this.idAmbiente, this.nomeAmbiente});

  @override
  _DetalhesSalaState createState() => _DetalhesSalaState();
}

class _DetalhesSalaState extends State<DetalhesSala> {
  int? temperaturaAtual;
  int? idFuncionario;

  @override
  void initState() {
    super.initState();
    _loadFuncionarioId();
  }

  Future<void> _loadFuncionarioId() async {
    final prefs = await SharedPreferences.getInstance();
    final getId = GetId(prefs);
    setState(() {
      idFuncionario = getId.pegarId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                TemperaturaProvider()..fetchTemperaturas(widget.idAmbiente)),
        ChangeNotifierProvider(
            create: (_) => FuncionarioProvider()..fetchFuncionarios()),
        ChangeNotifierProvider(
            create: (_) => UsuarioAmbienteProvider()
              ..fetchUsuarioAmbiente(widget.idAmbiente)),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.branco,
          title: Text("Detalhes da sala ${widget.nomeAmbiente}"),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/icon.png'),
          ),
        ),
        backgroundColor: AppColors.branco,
        body: Consumer3<TemperaturaProvider, FuncionarioProvider,
            UsuarioAmbienteProvider>(
          builder: (context, temperaturaProvider, funcionarioProvider,
              usuarioAmbienteProvider, child) {
            if (temperaturaProvider.carregando ||
                funcionarioProvider.carregando ||
                usuarioAmbienteProvider.carregando) {
              return const Center(child: CircularProgressIndicator());
            } else if (temperaturaProvider.mensagem != null ||
                funcionarioProvider.menssagem.isNotEmpty) {
              return Center(
                child: Text(temperaturaProvider.mensagem ??
                    funcionarioProvider.menssagem),
              );
            }

            final detalhes = temperaturaProvider.mudanca;

            if (detalhes == null) {
              return const Center(child: Text("Nenhum dado disponível."));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            temperaturaAtual = (temperaturaAtual ??
                                    detalhes.temperaturaAlterada) -
                                1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          backgroundColor: AppColors.azul,
                        ),
                        child: const Text(
                          "-",
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Temperatura: ${temperaturaAtual ?? detalhes.temperaturaAlterada}°C",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            temperaturaAtual = (temperaturaAtual ??
                                    detalhes.temperaturaAlterada) +
                                1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          backgroundColor: AppColors.azul,
                        ),
                        child: const Text(
                          "+",
                          style: TextStyle(
                            color: AppColors.branco,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    onPressed: () async {
                      temperaturaProvider.alterarTemperatura(
                        temperaturaAtual ?? detalhes.temperaturaAlterada,
                        detalhes.temperatura,
                        detalhes.idAmbiente,
                        idFuncionario ?? 0,
                      );
                    },
                    text: ("Salvar"),
                  ),
                  const SizedBox(height: 16),
                  Text("Temperatura alterada: ${detalhes.temperaturaAlterada}"),
                  Text("ID do Ambiente: ${detalhes.idAmbiente}"),
                  Text('Horário: ${detalhes.horarioMudanca}'),
                  const SizedBox(height: 20),
                  const Text("Funcionário associado:"),
                  if (idFuncionario != null) ...[
                    Text("ID do Funcionário: $idFuncionario"),
                  ] else ...[
                    const Text("Carregando ID do funcionário..."),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}