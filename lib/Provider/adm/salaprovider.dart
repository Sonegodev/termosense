import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:termosense/Models/sala.dart';
import 'package:http/http.dart' as http;

class AmbienteProvider with ChangeNotifier {
  bool _cadastrado = false;
  bool get cadastrado => _cadastrado;

  bool _carregando = false;
  bool get carregando => _carregando;

  String _mensagem = "";
  String get mensagem => _mensagem;

  List<Ambiente> _ambientes = [];
  List<Ambiente> get ambientes => _ambientes;

  String? _token;

  Future<void> pegarToken() async {
    var dados = await SharedPreferences.getInstance();
    _token = dados.getString("token");
    if (_token == null) {
      _mensagem = "Erro: Token não encontrado. Por favor, faça login novamente.";
      notifyListeners();
    }
  }

  Future<void> cadastrarAmbiente(Ambiente ambiente) async {
    const url = 'https://temmaxima.azurewebsites.net/api/Ambiente';

    try {
      await pegarToken();
      if (_token == null) return; 

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode(ambiente.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _cadastrado = true;
        _mensagem = "Sala Cadastrada com sucesso!";
      } else {
        _cadastrado = false;
        _mensagem = "Erro ao cadastrar Sala!";
      }
    } catch (error) {
      _mensagem = "Erro ao cadastrar Sala: $error";
      rethrow;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> fetchAmbientes() async {
    const url = 'https://temmaxima.azurewebsites.net/api/Ambiente';

    try {
      await pegarToken();
      if (_token == null) return; 
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _ambientes = data.map((json) => Ambiente.fromJson(json)).toList();
      } else {
        _mensagem = "Erro ao buscar ambientes: ${response.reasonPhrase}";
      }
    } catch (error) {
      _mensagem = "Erro ao buscar ambientes: $error";
      rethrow;
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> atualizarAmbiente(Ambiente ambiente) async {
    final url = 'https://temmaxima.azurewebsites.net/api/Ambiente/${ambiente.idAmbiente}';

    try {
      await pegarToken();
      if (_token == null) return; 

      _carregando = true;
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: json.encode(ambiente.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _mensagem = 'Ambiente atualizado com sucesso!';
        await fetchAmbientes(); 
      } else {
        _mensagem = 'Erro ao atualizar ambiente: ${response.body}';
      }
    } catch (error) {
      _mensagem = 'Erro ao atualizar ambiente: $error';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> deletarAmbiente(int id) async {
    final url = 'https://temmaxima.azurewebsites.net/api/Ambiente/$id';

    try {
      await pegarToken();
      if (_token == null) return;

      _carregando = true;
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _mensagem = 'Ambiente deletado com sucesso!';
        await fetchAmbientes();
      } else {
        _mensagem = 'Erro ao deletar ambiente: ${response.body}';
      }
    } catch (error) {
      _mensagem = 'Erro ao deletar ambiente: $error';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }
}
