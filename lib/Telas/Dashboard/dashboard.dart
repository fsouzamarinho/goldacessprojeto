import 'package:flutter/material.dart';
import 'package:goldsecurity/Style/colors.dart';
import 'package:goldsecurity/Widget/botao.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: const [Image(image: AssetImage('assets/images/logoTcc2.png'),)],
          title: Text("GoldAccess", style: TextStyle(color: branco)),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, Colors.white])),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                

            const SizedBox(height: 15),

            customButton(
              tap: (){
                Navigator.of(context).pushNamed('/cadastrarfunc');
              },
              text: 'Cadastrar Funcionário', 
            ),
            customButton(
              tap: (){
                Navigator.of(context).pushNamed('/cadastrarsalas');
              },
              text: 'Cadastrar Salas', 
            ),
            customButton(
              tap: (){
                Navigator.of(context).pushNamed('/exibirsalas');
              },
              text: 'Exibir Salas', 
            ),
            customButton(
              tap: (){
                Navigator.of(context).pushNamed('/exibirfuncionarios');
              },
              text: 'Funcionários', 
            ),
           ]
          ),
        )
      )
    );
  }
}
