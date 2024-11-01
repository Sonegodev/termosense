import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:termosense/Models/temperatura.dart';

class TemperaturaProvider with ChangeNotifier {
  List<Temperatura> _temperaturas = [];
  bool _carregando = false;
  String? _mensagem;
  String? _token;

  List<Temperatura> get temperaturas => _temperaturas;
  bool get carregando => _carregando;
  String? get mensagem => _mensagem;

  Future<void> pegarToken() async {
    final dados = await SharedPreferences.getInstance();
    _token = dados.getString("token");
    if (_token == null) {
      _mensagem = "Erro: Token não encontrado. Por favor, faça login novamente.";
      notifyListeners();
    }
  }

  Future<void> fetchTemperaturas(int idambiente) async {
    final url = Uri.parse('https://temmaxima.azurewebsites.net/api/Temperatura/$idambiente');
    
    _carregando = true;
    notifyListeners();

    try {
      await pegarToken();
      if (_token == null) return;

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        _temperaturas = data.map((json) => Temperatura.fromJson(json)).toList();

        _mensagem = null;
      } else {
        _mensagem = 'Erro ao carregar dados: ${response.statusCode}';
      }
    } catch (error) {
      _mensagem = 'Erro de conexão: $error';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}