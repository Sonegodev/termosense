import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:termosense/Models/mudancatemp.dart';
import 'package:termosense/Models/temperatura.dart';

class TemperaturaProvider with ChangeNotifier {
  MudancaTemperatura? _mudanca;
  List<Temperatura> _temperaturas = [];
  bool _carregando = false;
  String? _mensagem;
  String? _token;

  MudancaTemperatura? get mudanca => _mudanca;
  List<Temperatura> get temperaturas => _temperaturas;
  bool get carregando => _carregando;
  String? get mensagem => _mensagem;

  Future<void> pegarToken() async {
    final dados = await SharedPreferences.getInstance();
    _token = dados.getString("token");
    if (_token == null) {
      _mensagem =
          "Erro: Token não encontrado. Por favor, faça login novamente.";
      notifyListeners();
    }
  }

  Future<void> fetchTemperaturas(int idambiente) async {
    final url = Uri.parse(
        'https://temmaxima.azurewebsites.net/api/MudancaTemp/$idambiente');

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

      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> temperaturaDados =
            json.decode(response.body);
        _mudanca = MudancaTemperatura.fromJson(temperaturaDados);

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

  Future<void> alterarTemperatura(int temperaturaAlterada, int temperatura,
      int idAmbiente, int idFuncionario) async {
    final url =
        Uri.parse('https://temmaxima.azurewebsites.net/api/MudancaTemp');

    print(temperaturaAlterada);

    _carregando = true;
    notifyListeners();

    try {
      await pegarToken();
      if (_token == null) return;

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          'temperatura_alterada': temperaturaAlterada,
          'temperatura': temperatura,
          'idAmbiente': idAmbiente,
          'idFuncionario': idFuncionario,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _mensagem = 'Temperatura alterada com sucesso.';
      } else {
        _mensagem = 'Erro ao alterar temperatura: ${response.statusCode}';
      }
    } catch (error) {
      _mensagem = 'Erro de conexão: $error';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
} 