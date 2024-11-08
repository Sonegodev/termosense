import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Provider/adm/funcprovider.dart';
import 'package:termosense/Provider/adm/tempprovider.dart';
import 'package:termosense/Provider/adm/userambprovider.dart';
import 'package:termosense/style/colors.dart';

class DetalhesSala extends StatelessWidget {
  final int idAmbiente;
  final String? nomeAmbiente;

  const DetalhesSala({super.key, required this.idAmbiente, this.nomeAmbiente});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                TemperaturaProvider()..fetchTemperaturas(idAmbiente)),
        ChangeNotifierProvider(
            create: (_) => FuncionarioProvider()..fetchFuncionarios()),
        ChangeNotifierProvider(
            create: (_) => UsuarioAmbienteProvider()..fetchUsuarioAmbiente(idAmbiente)),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.branco,
          title: Text("Detalhes da sala $nomeAmbiente"),
        ),
        backgroundColor: AppColors.branco,
        body: Consumer3<TemperaturaProvider, FuncionarioProvider, UsuarioAmbienteProvider>(
          builder: (context, temperaturaProvider, funcionarioProvider, usuarioAmbienteProvider, child) {
            if (temperaturaProvider.carregando ||
                funcionarioProvider.carregando ||
                usuarioAmbienteProvider.carregando) {
              return const Center(child: CircularProgressIndicator());
            } else if (temperaturaProvider.mensagem != null ||
                funcionarioProvider.menssagem.isNotEmpty) {
              return Center(
                child: Text(temperaturaProvider.mensagem ?? funcionarioProvider.menssagem),
              );
            }
            final detalhes = temperaturaProvider.temperaturas;
            final funcionarioAssociado = usuarioAmbienteProvider.usuarioAmbiente;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (detalhes.isNotEmpty) ...[
                    Text("Temperatura: ${detalhes[0].temperatura}°C"),
                    Text("Horário da Temperatura: ${detalhes[0].horarioTemp}"),
                    Text("ID do Ambiente: ${detalhes[0].idAmbiente}"),
                  ] else ...[
                    const SizedBox(height: 20),
                    const Text('Nenhum dado de temperatura disponível.'),
                  ],
                  const SizedBox(height: 20),
                  const Text("Funcionário associado:"),
                  if (funcionarioAssociado != null) ...[
                    Text(funcionarioAssociado.idFuncionario as String),
                  ] else ...[
                    const Text("Nenhum funcionário associado a esta sala."),
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
