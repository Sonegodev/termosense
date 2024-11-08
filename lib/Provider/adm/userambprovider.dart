import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:termosense/Models/userambiente.dart';

class UsuarioAmbienteProvider with ChangeNotifier {
  bool _carregando = false;
  bool get carregando => _carregando;

  String _mensagem = "";
  String get mensagem => _mensagem;

  UsuarioAmbiente? _usuarioAmbiente;
  UsuarioAmbiente? get usuarioAmbiente => _usuarioAmbiente;

  String? token;

  Future<void> pegarToken() async {
    var dados = await SharedPreferences.getInstance();
    token = dados.getString("token");
  }

  Future<void> fetchUsuarioAmbiente(int id) async {
    final url = 'https://temmaxima.azurewebsites.net/api/UsuarioAmbiente/$id';

    try {
      await pegarToken();
      _carregando = true;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _usuarioAmbiente = UsuarioAmbiente.fromJson(data);
        _mensagem = "Dados carregados com sucesso!";
      } else {
        _mensagem = "Erro ao buscar os dados: ${response.body}";
      }
    } catch (error) {
      _mensagem = "Erro ao buscar os dados: $error";
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> cadastrarUsuarioAmbiente(UsuarioAmbiente usuarioAmbiente) async {
    const url = 'https://temmaxima.azurewebsites.net/api/UsuarioAmbiente';

    try {
      await pegarToken();
      _carregando = true;
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(usuarioAmbiente.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        _mensagem = "Usuário Ambiente cadastrado com sucesso!";
      } else {
        _mensagem = "Erro ao cadastrar: ${response.body}";
      }
    } catch (error) {
      _mensagem = "Erro ao cadastrar: $error";
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
