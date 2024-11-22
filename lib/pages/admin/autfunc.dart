import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Models/func.dart';
import 'package:termosense/Provider/adm/funcprovider.dart';
import 'package:termosense/Models/userambiente.dart';
import 'package:termosense/Provider/adm/userambprovider.dart';
import 'package:termosense/Provider/adm/salaprovider.dart';
import 'package:termosense/style/colors.dart';

class AutorizarFuncionario extends StatefulWidget {
  const AutorizarFuncionario({super.key});

  @override
  State<AutorizarFuncionario> createState() => _AutorizarFuncionarioState();
}

class _AutorizarFuncionarioState extends State<AutorizarFuncionario> {
  Funcionario? _selectedFuncionario;
  int? _selectedAmbienteId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FuncionarioProvider>(context, listen: false)
          .fetchFuncionarios();
      Provider.of<AmbienteProvider>(context, listen: false).fetchAmbientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autorizar Funcionário'),
        backgroundColor: AppColors.branco,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/icon.png'),
        ),
      ),
      backgroundColor: AppColors.branco,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown para selecionar o Funcionário
            Consumer<FuncionarioProvider>(
              builder: (context, funcionarioProvider, child) {
                if (funcionarioProvider.carregando) {
                  return const CircularProgressIndicator();
                }
                if (funcionarioProvider.funcionarios.isEmpty) {
                  return const Text('Nenhum funcionário encontrado.');
                }
                return DropdownButton<Funcionario>(
                  value: _selectedFuncionario,
                  hint: const Text('Selecione um Funcionário'),
                  isExpanded: true,
                  onChanged: (Funcionario? novoFuncionario) {
                    setState(() {
                      _selectedFuncionario = novoFuncionario;
                    });
                  },
                  items: funcionarioProvider.funcionarios.map((funcionario) {
                    return DropdownMenuItem<Funcionario>(
                      value: funcionario,
                      child: Text(funcionario.nomeUsuario),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),

            // Dropdown para selecionar o Ambiente
            Consumer<AmbienteProvider>(
              builder: (context, ambienteProvider, child) {
                if (ambienteProvider.carregando) {
                  return const CircularProgressIndicator();
                }
                if (ambienteProvider.ambientes.isEmpty) {
                  return const Text('Nenhum ambiente encontrado.');
                }
                return DropdownButton<int>(
                  value: _selectedAmbienteId,
                  hint: const Text('Selecione um Ambiente'),
                  isExpanded: true,
                  onChanged: (int? novoAmbienteId) {
                    setState(() {
                      _selectedAmbienteId = novoAmbienteId;
                    });
                  },
                  items: ambienteProvider.ambientes.map((ambiente) {
                    return DropdownMenuItem<int>(
                      value: ambiente.idAmbiente,
                      child: Text(ambiente.nomeAmbiente),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),

            // Botão para associar o funcionário ao ambiente
            Consumer<UsuarioAmbienteProvider>(
              builder: (context, usuarioAmbienteProvider, child) {
                return ElevatedButton(
                  onPressed: (_selectedFuncionario == null ||
                          _selectedAmbienteId == null)
                      ? null
                      : () async {
                          if (_selectedFuncionario != null &&
                              _selectedAmbienteId != null) {
                            UsuarioAmbiente novoUsuarioAmbiente =
                                UsuarioAmbiente(
                              idAmbiente: _selectedAmbienteId!,
                              idFuncionario: _selectedFuncionario!.idFunc,
                            );

                            await usuarioAmbienteProvider
                                .cadastrarUsuarioAmbiente(novoUsuarioAmbiente);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(usuarioAmbienteProvider.mensagem),
                              ),
                            );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulDegrade1,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}