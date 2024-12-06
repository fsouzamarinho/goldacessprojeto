import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldsecurity/Constrain/appUrl.dart';
import 'package:goldsecurity/Models/salas_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AmbienteProvider with ChangeNotifier {


  bool _cadastrado = false;
  bool get cadastrado => _cadastrado;

  bool _carregando = false;
  bool get carregando => _carregando;

  String _menssagem = "";
  String get menssagem => _menssagem;

  List<Sala> _ambientes = [];

  List<Sala> get ambientes => _ambientes;

  String? token;

Future<void> pegarToken() async {
    _carregando = true;
    var dados = await SharedPreferences.getInstance();
    token = dados.getString("token");
}

  
  Future<void> cadastrarAmbiente(Sala ambiente) async {
     final url = '${AppUrl.baseUrl}api/Sala';
    
    try {
      await pegarToken();
      final response = await http.post(
        Uri.parse(url),
        headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
        body: json.encode(ambiente.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
         _cadastrado = true;
         _carregando = false;
         _menssagem = "Sala Cadastrada com sucesso!";
        notifyListeners();
      } else {
        _cadastrado = false;
         _carregando = false;
         _menssagem = "Erro ao cadastrar Sala!";
         notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

   Future<void> fetchAmbientes() async {
      final url = '${AppUrl.baseUrl}api/Sala';
    try {
      await pegarToken();
      final response = await http.get(Uri.parse(url),
       headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _ambientes = data.map((json) => Sala.fromJson(json)).toList();
        _carregando = false;
        notifyListeners();
      } else {
        _carregando = false;
         notifyListeners();
      }
    } catch (error) {
      rethrow;
    }
  }

    // Método para atualizar uma sala existente
  Future<void> atualizarAmbiente(Sala sala) async {
    try {
      final response = await http.put(
        Uri.parse('https://controledeacesso.azurewebsites.net/api/Sala/${sala.salaId}'),
         headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode(sala.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        _menssagem = 'Sala atualizada com sucesso!';
        fetchAmbientes();
        notifyListeners();
      } else {
        _menssagem = 'Erro ao atualizar sala.';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }

  // Função para deletar um funcionário
  Future<void> deletarSala(int id) async {
    final url = Uri.parse('https://controledeacesso.azurewebsites.net/api/Sala/$id');

    try {
      final response = await http.delete(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200 || response.statusCode == 204) {
         _menssagem = 'Sala deletada com Sucesso';
        fetchAmbientes(); 
        notifyListeners();
      } else {
         _menssagem = 'Erro ao deletar Sala.';
        notifyListeners();
      }
    } catch (error) {
      _menssagem = 'Erro de conexão.';
      notifyListeners();
    }
  }
  
  Future<bool> associarFuncionarioSala({
    required int funcionarioId,
    required int salaId,
  }) async {
    const url =
        'https://controledeacesso.azurewebsites.net/Api/FuncionarioSala';
    
    final body = {
      "funcionarioSalaId": 0,
      "funcionarioId": funcionarioId,
      "salaId": salaId,
    };


    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        notifyListeners();
        return true;
      } else {
      _menssagem = 'Erro ao associar usuário!';
      notifyListeners();
        return false;
      }
    } catch (e) {
      _menssagem = 'Erro de conexão!';
      notifyListeners();
      return false;
    }
  }
  }
  
