import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldsecurity/Constrain/appUrl.dart';
import 'package:goldsecurity/Models/funcionari_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FuncionarioProvider with ChangeNotifier {
  bool _cadastrado = false;
  bool get cadastrado => _cadastrado;

  bool _deletado = false;
  bool get deletado => _deletado;

  bool _carregando = false;
  bool get carregando => _carregando;

  String _menssagem = "";
  String get menssagem => _menssagem;

  List<Funcionarios> _funcionarios = [];

  List<Funcionarios> get funcionarios => _funcionarios;

  String? token;

  Future<void> pegarToken() async {
    _carregando = true;
    var dados = await SharedPreferences.getInstance();
    token = dados.getString("token");
  }

  Future<void> cadastrarFunc(Funcionarios funcionario) async {
    try {
      final url = '${AppUrl.baseUrl}api/Funcionario';

      try {
        await pegarToken();
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
          _carregando = false;
          _menssagem = "Funcionário cadastrado com sucesso!";
          notifyListeners();
        } else {
          _cadastrado = false;
          _carregando = false;
          _menssagem = "Erro ao cadastrar funcionário!";
          notifyListeners();
        }
      } catch (error) {
        _cadastrado = false;
        _carregando = false;
        _menssagem = "Dados Incorretos ou Erro de Servidor";
      }
    } catch (e) {
      _carregando = false;
      _menssagem = "Erro ao conectar o servidor!";
      notifyListeners();
    }
  }

  Future<void> fetchFuncionario() async {
    final url = '${AppUrl.baseUrl}api/Funcionario';
    try {
      await pegarToken();
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _funcionarios =
            data.map((json) => Funcionarios.fromJson(json)).toList();
        _carregando = false;
        notifyListeners();
      } else {
        _menssagem = 'Erro: ${response.body}';
        _carregando = false;
        notifyListeners();
      }
    } catch (error) {
      _carregando = false;
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }

  // Método para atualizar um funcionário existente
  Future<void> atualizarFunc(Funcionarios funcionario) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://controledeacesso.azurewebsites.net/api/Funcionario/${funcionario.funcionarioId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(funcionario.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Funcionário atualizado com sucesso!';
        notifyListeners();
        fetchFuncionario();
      } else {
        _menssagem = 'Erro ao atualizar funcionário.';
        notifyListeners();
      }
    } catch (error) {
      _carregando = false;
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }

  // Função para deletar um funcionário
  Future<void> deletarFuncionario(int id) async {
    final url = Uri.parse(
        'https://controledeacesso.azurewebsites.net/api/Funcionario/$id');

    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Usuário Deletado com Sucesso';
        _deletado = true;
        fetchFuncionario();
        notifyListeners();
      } else {
        _deletado = false;
        _menssagem = 'Erro ao deletar funcionário.';
        notifyListeners();
      }
    } catch (error) {
      _carregando = false;
      _menssagem = 'Erro ao tentar excluir funcionário';
      notifyListeners();
    }
  }
}
