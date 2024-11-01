import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Provider/adm/tempprovider.dart';
import 'package:termosense/style/colors.dart';

class DetalhesSala extends StatelessWidget {
  final int idAmbiente;
  final String? nomeAmbiente;

  const DetalhesSala({super.key, required this.idAmbiente, this.nomeAmbiente});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TemperaturaProvider()..fetchTemperaturas(idAmbiente),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.branco,
          title: Text("Detalhes da $nomeAmbiente"),
        ),
        backgroundColor: AppColors.branco,
        body: Consumer<TemperaturaProvider>(
          builder: (context, temperaturaProvider, child) {
            if (temperaturaProvider.carregando) {
              return const Center(child: CircularProgressIndicator());
            } else if (temperaturaProvider.mensagem != null) {
              return Center(
                child: Text(
                    temperaturaProvider.mensagem ?? 'Erro ao carregar dados'),
              );
            }
            final detalhes = temperaturaProvider.temperaturas;
            if (detalhes.isEmpty) {
              return const Center(child: Text('Nenhum dado disponível.'));
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Temperatura: ${detalhes[0].temperatura}°C"),
                  Text("Horário da Temperatura: ${detalhes[0].horarioTemp}"),
                  Text("ID do Ambiente: ${detalhes[0].idAmbiente}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}