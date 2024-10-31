import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Provider/login/loginuser.dart';
import 'package:termosense/Utils/mensagem.dart';
import 'package:termosense/style/colors.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool isObscured = true;
  bool stayConnected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Logar>(builder: (context, usuario, _) {
      return Scaffold(
        backgroundColor: AppColors.branco,
        appBar: AppBar(
          backgroundColor: AppColors.branco,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/icon.png'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'inter18',
                  fontWeight: FontWeight.bold,
                  color: AppColors.azulTitulo,
                ),
              ),
              const SizedBox(height: 80),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: null,
                  filled: true,
                  fillColor: AppColors.branco,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
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
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        value: stayConnected,
                        activeColor: Colors.blue,
                        checkColor: Colors.white,
                        onChanged: (bool? value) {
                          setState(() {
                            stayConnected = value!;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text('Continuar Conectado'),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    child: const Text(
                      'Cadastrar-se',
                      style: TextStyle(
                        color: AppColors.azulTitulo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color.fromARGB(255, 75, 162, 255),
                      AppColors.azulDegrade1
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
                    usuario.validatePassword(_senhaController.text);
                    if (usuario.valido) {
                      await usuario.logarUsuario(
                          _emailController.text, _senhaController.text);
                      if (usuario.logado) {
                        Navigator.pushNamed(context, usuario.rota);
                      } else {
                        showMessage(
                            message: usuario.msgError, context: context);
                      }
                    } else {
                      showMessage(message: usuario.msgError, context: context);
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
                    'Entrar',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
