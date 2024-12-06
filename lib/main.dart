import 'package:flutter/material.dart';
import 'package:goldsecurity/Provider/Funcionario/funcionariop.dart';
import 'package:goldsecurity/Provider/FuncionarioSala/funcsalap.dart';
import 'package:goldsecurity/Provider/Login/loginUser.dart';
import 'package:goldsecurity/Provider/Salas/salas.dart';
import 'package:goldsecurity/Telas/BotaodeSaida/botaodesaida.dart';
import 'package:goldsecurity/Telas/Cadastrarfunc/cadastrarfunc.dart';
import 'package:goldsecurity/Telas/CadastrarSalas/cadastrarsalas.dart';
import 'package:goldsecurity/Telas/Dashboard/dashboard.dart';
import 'package:goldsecurity/Telas/ExibirFuncionarios/exibirfuncionarios.dart';
import 'package:goldsecurity/Telas/ExibirSalas/exibirsalas.dart';
import 'package:goldsecurity/Telas/FuncionarioSala/funcsala.dart';
import 'package:goldsecurity/Telas/Login/homepage.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
       ChangeNotifierProvider(create: (_) => Logar()),
       ChangeNotifierProvider(create: (_) => AmbienteProvider()),
       ChangeNotifierProvider(create: (_) => FuncionarioProvider()),
       ChangeNotifierProvider(create: (_) => FuncSalaProvider()),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/":(context) => Homepage(),
        "/dashfunc":(context) => const Botaodesaida(),
        "/dashboard":(context) => const Dashboard(),
        "/cadastrarfunc":(context) => const CadastrarFunc(),
        "/cadastrarsalas":(context) => const CadastrarSalas(),
        "/exibirsalas":(context) => const ExibirSalas(),
        "/exibirfuncionarios":(context) => const ExibirFuncionarios(),
        '/funcsalas':(context) => const FuncSala(),
      },
    ),
  ));
}

