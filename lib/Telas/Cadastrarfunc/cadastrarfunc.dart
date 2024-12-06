import 'package:flutter/material.dart';
import 'package:goldsecurity/Models/funcionari_models.dart';
import 'package:goldsecurity/Provider/Funcionario/funcionariop.dart';
import 'package:goldsecurity/Style/colors.dart';
import 'package:goldsecurity/Utils/msg.dart';
import 'package:goldsecurity/Widget/botao.dart';
import 'package:goldsecurity/Widget/textfild.dart';
import 'package:provider/provider.dart';

class CadastrarFunc extends StatefulWidget {
  final Funcionarios? funcionario;

  const CadastrarFunc({Key? key, this.funcionario}) : super(key: key);

  @override
  State<CadastrarFunc> createState() => _CadastrarFuncState();
}

class _CadastrarFuncState extends State<CadastrarFunc> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _rfidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cargoController = TextEditingController();
  final _turnoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.funcionario != null) {
      _nomeController.text = widget.funcionario!.nome;
      _emailController.text = widget.funcionario!.email;
      _cpfController.text = widget.funcionario!.cpf;
      _rfidController.text = widget.funcionario!.rfid;
      _passwordController.text = widget.funcionario!.password;
      _telefoneController.text = widget.funcionario!.telefone;
      _cargoController.text = widget.funcionario!.cargo;
      _turnoController.text = widget.funcionario!.turno;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Image(image: AssetImage('assets/images/logoTcc2.png')),
        ],
        title: Text(
          widget.funcionario == null ? "Cadastrar Funcionário" : "Editar Funcionário",
          style: TextStyle(color: branco),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, Colors.white],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Consumer<FuncionarioProvider>(
              builder: (context, funcProvider, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      customTextField(
                        tcontroller: _nomeController,
                        title: 'Nome',
                        hint: 'Digite seu nome',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O campo Nome é obrigatório.';
                          }
                          return null;
                        },
                      ),
                      customTextField(
                        tcontroller: _emailController,
                        title: 'Email',
                        hint: 'Digite seu e-mail',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O campo Email é obrigatório.';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Digite um e-mail válido.';
                          }
                          return null;
                        },
                      ),
                      customTextField(
                        tcontroller: _passwordController,
                        title: 'Senha',
                        hint: 'Digite sua senha',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O campo Senha é obrigatório.';
                          }
                          if (value.length < 6) {
                            return 'A senha deve ter pelo menos 6 caracteres.';
                          }
                          return null;
                        },
                      ),
                      customTextField(
                        tcontroller: _rfidController,
                        title: 'RFID',
                        hint: 'Digite seu RFID',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O campo RFID é obrigatório.';
                          }
                          return null;
                        },
                      ),
                      customTextField(
                        tcontroller: _cpfController,
                        title: 'CPF',
                        hint: 'Digite seu CPF',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O campo CPF é obrigatório.';
                          }
                          if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                            return 'Digite um CPF válido (apenas números).';
                          }
                          return null;
                        },
                      ),
                      customTextField(
                        tcontroller: _telefoneController,
                        title: 'Número de Telefone',
                        hint: 'Digite seu número de telefone',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O campo Telefone é obrigatório.';
                          }
                          if (!RegExp(r'^\d+$').hasMatch(value)) {
                            return 'Digite um número de telefone válido.';
                          }
                          return null;
                        },
                      ),
                      customTextField(
                        tcontroller: _cargoController,
                        title: 'Cargo',
                        hint: 'Digite seu cargo',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O campo Cargo é obrigatório.';
                          }
                          return null;
                        },
                      ),
                      customTextField(
                        tcontroller: _turnoController,
                        title: 'Turno',
                        hint: 'Digite seu turno',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O campo Turno é obrigatório.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      customButton(
                        text: widget.funcionario == null ? 'Cadastrar' : 'Salvar Alterações',
                        tap: () async {
                          if (_formKey.currentState!.validate()) {
                            final funcionario = Funcionarios(
                              funcionarioId: widget.funcionario?.funcionarioId,
                              nome: _nomeController.text.trim(),
                              email: _emailController.text.trim(),
                              cpf: _cpfController.text.trim(),
                              rfid: _rfidController.text.trim(),
                              password: _passwordController.text.trim(),
                              telefone: _telefoneController.text.trim(),
                              cargo: _cargoController.text.trim(),
                              turno: _turnoController.text.trim(),
                            );

                            if (widget.funcionario == null) {
                              await funcProvider.cadastrarFunc(funcionario);
                            } else {
                              await funcProvider.atualizarFunc(funcionario);
                            }

                            if(funcProvider.cadastrado){
                              showMessage(message: funcProvider.menssagem, context: context);
                            Navigator.of(context).pushNamed("/exibirfuncionarios");
                            } else {
                              showMessage(message: funcProvider.menssagem, context: context);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
