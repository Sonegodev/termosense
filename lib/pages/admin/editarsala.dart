import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Models/sala.dart';
import 'package:termosense/Provider/adm/salaprovider.dart';
import 'package:termosense/Utils/mensagem.dart';
import 'package:termosense/btn/button.dart';
import 'package:termosense/style/colors.dart';

class Editarsala extends StatefulWidget {
  final Ambiente ambiente;

  const Editarsala({super.key, required this.ambiente});

  @override
  _EditarsalaState createState() => _EditarsalaState();
}

class _EditarsalaState extends State<Editarsala> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.ambiente.nomeAmbiente);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoes() async {
    if (_formKey.currentState?.validate() ?? false) {
      final ambienteAtualizado = widget.ambiente.copyWith(
        nomeAmbiente: _nomeController.text,
      );

      await Provider.of<AmbienteProvider>(context, listen: false)
          .atualizarAmbiente(ambienteAtualizado);

      showMessage(
        message: Provider.of<AmbienteProvider>(context, listen: false).mensagem,
        context: context,
      );

      Navigator.of(context).pop(); // Fecha a tela após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Sala'),
        backgroundColor: AppColors.branco,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/icon.png'),
        ),
      ),
      backgroundColor: AppColors.branco,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Sala',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome da sala não pode ser vazio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: _salvarAlteracoes,
                text: ('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}