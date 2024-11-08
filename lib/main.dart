import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:termosense/Provider/adm/funcprovider.dart';
import 'package:termosense/Provider/adm/salaprovider.dart';
import 'package:termosense/Provider/adm/userambprovider.dart';
import 'package:termosense/Provider/login/loginuser.dart';
import 'package:termosense/pages/admin/listsala.dart';
import 'package:termosense/pages/homepage.dart';
import 'package:termosense/pages/login.dart';
import 'package:termosense/pages/usuario/cadastro.dart';
import 'package:termosense/pages/admin/cadastrofunc.dart';
import 'package:termosense/pages/admin/listfunc.dart';
import 'package:termosense/pages/admin/cadsala.dart';
import 'package:termosense/pages/usuario/sala.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Logar()),
      ChangeNotifierProvider(create: (_) => AmbienteProvider()),
      ChangeNotifierProvider(create: (_) => FuncionarioProvider()),
      ChangeNotifierProvider(create: (_) => UsuarioAmbienteProvider()),

    ],
    child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Homepage(),
        '/login': (context) => const Login(),
        '/salas': (context) => const Sala(),
        '/cadastro': (context) => const Cadastro(),
        '/cadsala': (context) => const CadastroAmbiente(),
        '/cadfunc': (context) => const CadastroFunc(),
        '/listafunc': (context) => const ListaFuncionarios(),
        '/listasala': (context) => const ListaAmbientes()
      },
      debugShowCheckedModeBanner: false,
    ),
  ));
}
