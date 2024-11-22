import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:termosense/Models/func.dart';
import 'package:termosense/Models/userambiente.dart';
import 'package:termosense/Provider/adm/userambprovider.dart';

class FuncionarioProvider with ChangeNotifier {
  bool _cadastrado = false;
  bool get cadastrado => _cadastrado;

  bool _carregando = false;
  bool get carregando => _carregando;

  String _menssagem = "";
  String get menssagem => _menssagem;

  List<Funcionario> _funcionarios = [];
  List<Funcionario> get funcionarios => _funcionarios;

  String? token;

  Future<void> pegarToken() async {
    var dados = await SharedPreferences.getInstance();
    token = dados.getString("token");
  }

  Future<void> cadastrarFuncionario(Funcionario funcionario) async {
    const url = 'https://temmaxima.azurewebsites.net/api/Funcionario';

    try {
      await pegarToken();
      _carregando = true;
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(funcionario.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        _cadastrado = true;
        _menssagem = "Funcionário cadastrado com sucesso!";
        await fetchFuncionarios();
      } else {
        _cadastrado = false;
        _menssagem = "Erro ao cadastrar funcionário: ${response.body}";
      }
    } catch (error) {
      _cadastrado = false;
      _menssagem = "Erro ao cadastrar funcionário: $error";
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> fetchFuncionarios() async {
    const url = 'https://temmaxima.azurewebsites.net/api/Funcionario';

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
        final List<dynamic> data = json.decode(response.body);
        _funcionarios = data.map((json) => Funcionario.fromJson(json)).toList();
      } else {
        _menssagem = "Erro ao buscar funcionários: ${response.body}";
      }
    } catch (error) {
      _menssagem = "Erro ao buscar funcionários: $error";
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> fetchFuncionarioPorSala(int idAmbiente) async {
    const urlBase = 'https://temmaxima.azurewebsites.net/api/UsuarioAmbiente';

    try {
      await pegarToken();
      _carregando = true;
      // Buscar os funcionários associados ao ambiente
      final response = await http.get(
        Uri.parse('$urlBase/$idAmbiente'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final usuarioAmbiente = UsuarioAmbiente.fromJson(data);
        
        // Aqui, você pode buscar o funcionário correspondente ao idFuncionario
        final funcionarioResponse = await http.get(
          Uri.parse('https://temmaxima.azurewebsites.net/api/Funcionario/${usuarioAmbiente.idFuncionario}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
        
        if (funcionarioResponse.statusCode == 200) {
          final funcionarioData = json.decode(funcionarioResponse.body);
          final funcionario = Funcionario.fromJson(funcionarioData);
          _funcionarios = [funcionario]; 
        } else {
          _menssagem = "Erro ao buscar funcionário associado.";
        }
      } else {
        _menssagem = "Erro ao buscar dados do ambiente.";
      }
    } catch (error) {
      _menssagem = "Erro ao buscar funcionário: $error";
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<void> atualizarFunc(Funcionario funcionario) async {
    try {
      await pegarToken();
      final response = await http.put(
        Uri.parse('https://temmaxima.azurewebsites.net/api/Funcionario/${funcionario.idFunc}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(funcionario.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Funcionário atualizado com sucesso!';
        notifyListeners();
        fetchFuncionarios();
      } else {
        _menssagem = 'Erro ao atualizar funcionário.';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }

  Future<void> deletarFuncionario(int id) async {
    final url = Uri.parse('https://temmaxima.azurewebsites.net/api/Funcionario/$id');

    try {
      await pegarToken();
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Usuário Deletado com Sucesso';
        fetchFuncionarios();
        notifyListeners();
      } else {
        _menssagem = 'Erro ao deletar funcionário.';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }
}
