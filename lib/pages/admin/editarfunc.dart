import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Models/func.dart';
import 'package:termosense/Provider/adm/funcprovider.dart';
import 'package:termosense/Utils/mensagem.dart';
import 'package:termosense/btn/button.dart';
import 'package:termosense/style/colors.dart';

class Editarfunc extends StatefulWidget {
  final Funcionario funcionario;

  const Editarfunc({super.key, required this.funcionario});

  @override
  _EditarfuncState createState() => _EditarfuncState();
}

class _EditarfuncState extends State<Editarfunc> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.funcionario.nomeUsuario);
    _emailController = TextEditingController(text: widget.funcionario.email);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _salvarAlteracoesFunc() async {
    if (_formKey.currentState?.validate() ?? false) {
      final funcionarioAtualizado = widget.funcionario.copyWith(
        nomeUsuario: _nomeController.text,
        email: _emailController.text,
      );

      await Provider.of<FuncionarioProvider>(context, listen: false)
          .atualizarFunc(funcionarioAtualizado);

      showMessage(
        message: Provider.of<FuncionarioProvider>(context, listen: false).menssagem,
        context: context,
      );

      Navigator.of(context).pop(); // Fecha a tela após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Funcionário'),
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
                  labelText: 'Nome do Funcionário',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O nome do funcionário não pode ser vazio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail do Funcionário',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O e-mail do funcionário não pode ser vazio';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              CustomElevatedButton(
                onPressed: _salvarAlteracoesFunc,
                text: ('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
