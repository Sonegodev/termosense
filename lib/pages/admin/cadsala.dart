import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Models/sala.dart';
import 'package:termosense/Provider/adm/salaprovider.dart';
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

  @override
  void initState() {
    super.initState();
    if (widget.ambiente != null) {
    _nomeController.text = widget.ambiente!.nomeAmbiente;
  }
}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Sala'),
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
            // Campo de texto estilizado
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do Ambiente',
                border: null,
                filled: true,
                fillColor: AppColors.branco,
              ),
            ),
            const SizedBox(height: 40),

            // Botão estilizado
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
                          final ambiente = Ambiente(idAmbiente: 0, nomeAmbiente: _nomeController.text);
                          await salaProvider.cadastrarAmbiente(ambiente);
                          if (salaProvider.cadastrado == true) {
                            _nomeController.clear();
                          }
                          showMessage(message: salaProvider.mensagem, context: context);
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
