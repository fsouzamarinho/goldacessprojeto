import 'package:flutter/material.dart';
import 'package:goldsecurity/Provider/Login/loginUser.dart';
import 'package:goldsecurity/Style/colors.dart';
import 'package:goldsecurity/Telas/BotaodeSaida/botaodesaida.dart';
import 'package:goldsecurity/Utils/msg.dart';
import 'package:goldsecurity/Widget/botao.dart';
import 'package:goldsecurity/Widget/textfild.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _isPasswordVisible = false; // Controle de visibilidade da senha

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GoldAccess", style: TextStyle(color: branco)),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Consumer<Logar>(builder: (context, usuario, _) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, Colors.white],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/images/logoTcc2.png'),
                    width: 200,
                    height: 200,
                  ),
                  Text(
                    'Bem-Vindo',
                    style: TextStyle(color: branco, fontSize: 27),
                  ),
                  const SizedBox(height: 30),
                  customTextField(
                    title: 'Email',
                    hint: 'Digite seu e-mail',
                    tcontroller: _emailController,
                  ),
                  customTextField(
                    title: 'Senha',
                    hint: 'Digite sua senha',
                    tcontroller: _senhaController,
                    obscureTexto: !_isPasswordVisible, // Inverte a visibilidade
                    onTogglePasswordVisibility: _togglePasswordVisibility, // Define a ação do botão
                    isPasswordVisible: _isPasswordVisible, // Atualiza o estado no TextField
                  ),
                  const SizedBox(height: 30),
                  usuario.carregando
                      ? const CircularProgressIndicator()
                      : customButton(
                          tap: () async {
                            await usuario.logarUsuario(
                              _emailController.text,
                              _senhaController.text,
                            );
                            if (usuario.logado &&
                                usuario.rota == "/dashfunc") {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => Botaodesaida(
                                  funcionario: usuario.colaborador,
                                ),
                              ));
                            } else if (usuario.logado &&
                                usuario.rota == "/dashboard") {
                              Navigator.of(context).pushNamed(usuario.rota);
                            } else {
                              showMessage(
                                message: usuario.msgError,
                                context: context,
                              );
                            }
                          },
                          text: 'Login',
                        ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
