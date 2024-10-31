import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Models/func.dart';
import 'package:termosense/Provider/adm/funcprovider.dart';
import 'package:termosense/Utils/mensagem.dart';
import 'package:termosense/style/colors.dart';

class CadastroFunc extends StatefulWidget {
  final Funcionario? funcionario;

  const CadastroFunc({super.key, this.funcionario});

  @override
  _CadastroFuncState createState() => _CadastroFuncState();
}

class _CadastroFuncState extends State<CadastroFunc> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _cpfController = TextEditingController();
  bool isObscured = true; 

  @override
  void initState() {
    super.initState();

    if (widget.funcionario != null) {
      _nomeController.text = widget.funcionario!.nomeUsuario;
      _emailController.text = widget.funcionario!.email;
      _senhaController.text = widget.funcionario!.senha;
      _cpfController.text = widget.funcionario!.cpf;
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: null,
                  filled: true,
                  fillColor: AppColors.branco,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: null,
                  filled: true,
                  fillColor: AppColors.branco,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _senhaController,
                obscureText: isObscured,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: null,
                  filled: true,
                  fillColor: AppColors.branco,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  border: null,
                  filled: true,
                  fillColor: AppColors.branco,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CPF';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Consumer<FuncionarioProvider>(builder: (context, provider, child) {
                return Container(
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
                      if (_formKey.currentState!.validate()) {
                        final funcionario = Funcionario(
                          idFunc: widget.funcionario?.idFunc ?? 0,
                          nomeUsuario: _nomeController.text,
                          email: _emailController.text,
                          senha: _senhaController.text,
                          cpf: _cpfController.text,
                          adm: false,
                        );

                        if (widget.funcionario == null) {
                          await provider.cadastrarFuncionario(funcionario);
                        } else {
                          await provider.atualizarFunc(funcionario);
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(provider.menssagem)),
                        );
                        _nomeController.clear();
                        _emailController.clear();
                        _senhaController.clear();
                        _cpfController.clear();
                        showMessage(message: provider.menssagem, context: context);
                        Navigator.pop(context);
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
                      'Cadastrar Funcionário',
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
      ),
    );
  }
}
