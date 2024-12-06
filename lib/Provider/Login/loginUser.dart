import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:goldsecurity/Constrain/appUrl.dart';
import 'package:goldsecurity/Data/spUser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Logar extends ChangeNotifier {
  bool _valido = false;
  bool _logado = false;
  String _msgError = '';
  bool _carregando = false;
  String _rota = "";
  int _colaborador = 0;

  bool get valido => _valido;
  bool get logado => _logado;
  String get msgError => _msgError;
  bool get carregando => _carregando;
  String get rota => _rota;

  int get colaborador => _colaborador;

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

//Logar usuário
  Future logarUsuario(String email, String password) async {
    try {
      _carregando = true;
      notifyListeners();
      String url = '${AppUrl.baseUrl}api/UserLogin/Login';
      debugPrint(url);

      Map<String, dynamic> requestBody = {
        "email": email,
        "password": password,
        "cpf": "0"
      };

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
        _colaborador = dados['id'];
       
        if (dados['roles'][0] == "Basic") {
          _rota = "/dashfunc";
        } else {
          _rota = "/dashboard";
        }

        _logado = true;
        notifyListeners();
      } else {
        _msgError = 'Usuario e senha invalidos';
        _logado = false;
        notifyListeners();
      }
    } catch (e) {
      _carregando = false;
      _msgError = 'Erro canectar ao servidor!';
      notifyListeners();
    }
  }
}
