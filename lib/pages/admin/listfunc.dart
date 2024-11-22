import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Provider/adm/funcprovider.dart';
import 'package:termosense/Utils/mensagem.dart';
import 'package:termosense/pages/admin/cadastrofunc.dart';
import 'package:termosense/pages/admin/editarfunc.dart';
import 'package:termosense/style/colors.dart';

class ListaFuncionarios extends StatefulWidget {
  const ListaFuncionarios({super.key});

  @override
  State<ListaFuncionarios> createState() => _ListaFuncionariosState();
}

class _ListaFuncionariosState extends State<ListaFuncionarios> {
  @override
  void initState() { 
    super.initState();
    Provider.of<FuncionarioProvider>(context, listen: false)
        .fetchFuncionarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Funcionários'),
        backgroundColor: AppColors.branco,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/icon.png'),
        ),
      ),
      backgroundColor: AppColors.branco,
      body: Consumer<FuncionarioProvider>(
        builder: (context, funcionariop, child) {
          if (funcionariop.funcionarios.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: funcionariop.funcionarios.length,
            itemBuilder: (context, index) {
              final funcionario = funcionariop.funcionarios[index];
              return ListTile(
                title: Text(funcionario.nomeUsuario),
                subtitle: Text('ID: ${funcionario.idFunc}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Editarfunc(
                                            funcionario: funcionario),
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
                                            'Tem certeza de que deseja excluir o funcionário ${funcionario.nomeUsuario}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
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
                                      await funcionariop.deletarFuncionario(
                                              funcionario.idFunc);
                                              showMessage(message: funcionariop.menssagem, context: context);
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
