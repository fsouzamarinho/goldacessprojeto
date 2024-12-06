import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldsecurity/Constrain/appUrl.dart';
import 'package:goldsecurity/Models/funcionari_models.dart';
import 'package:goldsecurity/Models/funcsalamodel.dart';
import 'package:goldsecurity/Models/salas_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FuncSalaProvider with ChangeNotifier {
  bool _acionarsala = false;
  bool get acionarsala => _acionarsala;

  final _cadastrado = false;
  bool get cadastrado => _cadastrado;

  bool _carregando = false;
  bool get carregando => _carregando;

  String _menssagem = "";
  String get menssagem => _menssagem;

  List<FuncionarioSala> _ambientes = [];

  List<FuncionarioSala> get ambientes => _ambientes;

  List<Funcionarios> _funcionarios = [];

  List<Funcionarios> get funcionarios => _funcionarios;

  List<Sala> _salasfuncionario = [];
  List<Sala> get salasfuncionario => _salasfuncionario;

  String? token;

  Future<void> pegarToken() async {
    _carregando = true;
    var dados = await SharedPreferences.getInstance();
    token = dados.getString("token");
  }

  Future<void> fetchSalas(int idSala) async {
    final url = '${AppUrl.baseUrl}api/Sala/Sala/$idSala';
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
        _carregando = false;
        notifyListeners();
      }
    } catch (error) {
      _carregando = false;
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }

  Future<void> fetchSalasFuncionario(int idSala) async {
    final url = '${AppUrl.baseUrl}api/Sala/Funcionario/$idSala';
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
        _salasfuncionario = data.map((json) => Sala.fromJson(json)).toList();
        _carregando = false;
        notifyListeners();
      } else {
        _carregando = false;
        notifyListeners();
      }
    } catch (error) {
      _carregando = false;
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }

  Future<void> acionarSala(int idSala) async {
    final url = '${AppUrl.baseUrl}api/Sala/Aciona?id=$idSala&aciona=true';
    try {
      await pegarToken();
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _acionarsala = true;
        _menssagem = 'Sala acionada com sucesso';
        _carregando = false;
        fetchSalas(idSala);
        notifyListeners();
        fetchSalasFuncionario(5);
      } else {
        _carregando = false;
        _acionarsala = false;
        _menssagem = 'Erro ao acionar sala';
        notifyListeners();
      }
    } catch (error) {
      _carregando = false;
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }

  Future<void> deletarFuncionario(int funcionarioId, int salaId) async {
    final url = '${AppUrl.baseUrl}api/FuncionarioSala/$funcionarioId $salaId';
    try {
      await pegarToken();
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Funcionário removido com sucesso';
        _funcionarios
            .removeWhere((func) => func.funcionarioId == funcionarioId);
        notifyListeners();
      } else {
        _menssagem = 'Erro ao deletar o funcionário';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }
}
