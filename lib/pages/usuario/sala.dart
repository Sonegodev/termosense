import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Provider/adm/salaprovider.dart';
import 'package:termosense/Utils/mensagem.dart';
import 'package:termosense/pages/admin/cadsala.dart';
import 'package:termosense/pages/admin/listsala.dart';
import 'package:termosense/style/colors.dart';

class Sala extends StatefulWidget {
  const Sala({super.key});

  @override
  _ListaAmbientesState createState() => _ListaAmbientesState();
}

class _ListaAmbientesState extends State<ListaAmbientes> {
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/cadsala');
            },
            icon: const Icon(Icons.add),
          ),
        ],
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
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CadastroAmbiente(ambiente: ambiente),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () async {
                        bool? confirm = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar Exclusão'),
                            content: Text(
                                'Tem certeza de que deseja excluir o ambiente ${ambiente.nomeAmbiente}?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Confirmar'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await Provider.of<AmbienteProvider>(context,
                                  listen: false)
                              .deletarAmbiente(ambiente.idAmbiente);
                          showMessage(
                            message: Provider.of<AmbienteProvider>(context,
                                    listen: false)
                                .mensagem,
                            context: context,
                          );
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
