import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:termosense/Constrain/url.dart';
import 'package:http/http.dart' as http;
import 'package:termosense/DataUser/usersp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Logar extends ChangeNotifier {
  bool _valido = false;
  bool _logado = false;
  String _msgError = '';
  bool _carregando = false;
  String _rota = "";
  bool _criado = false;

  bool get valido => _valido;
  bool get logado => _logado;
  String get msgError => _msgError;
  bool get carregando => _carregando;
  String get rota => _rota;
  bool get criado => _criado;

  void validatePassword(String password) {
    _msgError = '';
    if (password.length < 8) {
      _msgError = 'Mínimo 8 dígitos';
    } else if (!password.contains(RegExp(r'[a-z]'))) {
      _msgError = 'Pelo menos uma letra minúscula';
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      _msgError = 'Pelo menos uma letra maiúscula';
    } else if (!password
        .contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{};:\|,.<>\/?]'))) {
      _msgError = 'Pelo menos um carácter especial';
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      _msgError = 'Pelo menos um número';
    }
    _valido = _msgError.isEmpty;
    notifyListeners();
  }

  Future logarUsuario(String email, String password, {bool stayConnected = false}) async {
    _carregando = true;
    notifyListeners();
    String url = '${AppUrl.baseUrl}api/UserLogin/Login';
    debugPrint(url);

    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "cpf": "0"
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      _carregando = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map dados = jsonDecode(response.body);

        SharedPreferences idUser = await SharedPreferences.getInstance();

        var ds = GetId(idUser);
        await ds.gravarToken(dados['token']);
        await ds.gravarNivel(dados['roles'][0]);

        // Armazena estado de "continuar conectado"
        if (stayConnected) {
          await idUser.setBool('stayConnected', true);
        }

        if (dados['roles'][0] == "Basic") {
          _rota = "/salas";
        } else {
          _rota = "/listasala";
        }

        _logado = true;
        notifyListeners();
      } else {
        _msgError = 'Usuario e senha invalidos';
        _logado = false;
        notifyListeners();
      }
    } catch (e) {
      _msgError = "Erro ao tentar conectar ao serviço!";
      notifyListeners();
    }
  }

  Future<bool> verificarSessao() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('stayConnected') ?? false;
  }

  void deslogar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _logado = false;
    notifyListeners();
  }

  Future confirmarUsuario(String email, String password, String cpf) async {
    _carregando = true;
    notifyListeners();
    String url = '${AppUrl.baseUrl}api/UserLogin/Criar';
    debugPrint(url);

    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
      "cpf": cpf
    };

    print(requestBody);

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      _carregando = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        _criado = true;
        _msgError = 'Usuario criado com sucesso!';
        notifyListeners();
      } else {
        _msgError = 'Usuario e senha invalidos ou ocorreu algum erro';
        _criado = false;
        notifyListeners();
      }
    } catch (e) {
      _msgError = "Erro ao tentar conectar ao serviço!";
      notifyListeners();
    }
  }
}
