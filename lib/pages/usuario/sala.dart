import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Provider/adm/salaprovider.dart';
import 'package:termosense/Utils/mensagem.dart';
import 'package:termosense/pages/admin/cadsala.dart';
import 'package:termosense/pages/admin/detalhesala.dart';
import 'package:termosense/style/colors.dart';

class  Sala extends StatefulWidget {
  const  Sala({super.key});

  @override
  _SalaState createState() => _SalaState();
}

class _SalaState extends State<Sala> {
  @override
  void initState() {
    super.initState();
    Provider.of<AmbienteProvider>(context, listen: false).fetchAmbientes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.branco,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/icon.png'),
        ),
        actions: [],
      ),
      backgroundColor: AppColors.branco,
      body: Consumer<AmbienteProvider>(
        builder: (context, ambienteProvider, child) {
          if (ambienteProvider.ambientes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: ambienteProvider.ambientes.length,
            itemBuilder: (context, index) {
              final ambiente = ambienteProvider.ambientes[index];
              return ListTile(
                title: Text(ambiente.nomeAmbiente),
                subtitle: Text('ID: ${ambiente.idAmbiente}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                ),
              );
            },
          );
        },
      ),
    );
  }
}