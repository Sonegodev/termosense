import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Models/sala.dart';
import 'package:termosense/Models/func.dart';
import 'package:termosense/Models/userambiente.dart';
import 'package:termosense/Provider/adm/funcprovider.dart';
import 'package:termosense/Provider/adm/salaprovider.dart';
import 'package:termosense/Provider/adm/userambprovider.dart';
import 'package:termosense/Utils/mensagem.dart';
import 'package:termosense/style/colors.dart';

class CadastroAmbiente extends StatefulWidget {
  final Ambiente? ambiente;

  const CadastroAmbiente({super.key, this.ambiente});

  @override
  _CadastroAmbienteState createState() => _CadastroAmbienteState();
}

class _CadastroAmbienteState extends State<CadastroAmbiente> {
  final _nomeController = TextEditingController();
  Funcionario?
      _selectedFuncionario; // Variável para armazenar o funcionário selecionado

  @override
  void initState() {
    super.initState();
    if (widget.ambiente != null) {
      _nomeController.text = widget.ambiente!.nomeAmbiente;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FuncionarioProvider>(context, listen: false)
          .fetchFuncionarios();
    });
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
      ),
      backgroundColor: AppColors.branco,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Ambiente',
                border: null,
                filled: true,
                fillColor: AppColors.branco,
              ),
            ),
            const SizedBox(height: 20),
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
                      child: Text(funcionario
                          .nomeUsuario),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 40),
            Consumer<AmbienteProvider>(builder: (context, salaProvider, child) {
              return salaProvider.carregando
                  ? const CircularProgressIndicator()
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Color.fromARGB(255, 75, 162, 255),
                            AppColors.azulDegrade1,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final ambiente = Ambiente(
                            idAmbiente: 0,
                            nomeAmbiente: _nomeController.text,
                          );
                          await salaProvider.cadastrarAmbiente(ambiente);
                          if (salaProvider.cadastrado == true) {
                            _nomeController.clear();
                          }
                          showMessage(
                            message: salaProvider.mensagem,
                            context: context,
                          );

                          if (salaProvider.idAmbienteCadastrado != null &&
                              _selectedFuncionario != null) {
                            final usuarioAmbiente = UsuarioAmbiente(
                              idUsuarioAmbiente: 0,
                              idAmbiente: salaProvider
                                  .idAmbienteCadastrado!,
                              idFuncionario: _selectedFuncionario!
                                  .idFunc,
                            );

                            final usuarioAmbienteProvider =
                                Provider.of<UsuarioAmbienteProvider>(context,
                                    listen: false);
                            await usuarioAmbienteProvider
                                .cadastrarUsuarioAmbiente(usuarioAmbiente);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Cadastrar',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
