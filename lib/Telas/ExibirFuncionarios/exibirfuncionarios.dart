import 'package:flutter/material.dart';
import 'package:goldsecurity/Provider/Funcionario/funcionariop.dart';
import 'package:goldsecurity/Style/colors.dart';
import 'package:goldsecurity/Telas/Cadastrarfunc/cadastrarfunc.dart';
import 'package:goldsecurity/Utils/msg.dart';
import 'package:provider/provider.dart';

class ExibirFuncionarios extends StatefulWidget {
  const ExibirFuncionarios({super.key});

  @override
  State<ExibirFuncionarios> createState() => _ExibirFuncionariosState();
}

class _ExibirFuncionariosState extends State<ExibirFuncionarios> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<FuncionarioProvider>(context, listen: false).fetchFuncionario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastrarfunc');
                },
                child: Text(
                  "+ Funcionário",
                  style: TextStyle(
                    color: branco,
                    fontWeight: FontWeight.w600,
                  ),
                ))
          ],
          title: Text("Exibir Funcionarios", style: TextStyle(color: branco)),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [primaryColor, Colors.white])),
            child: Consumer<FuncionarioProvider>(
              builder: (context, funcProvider, child) {
                if (funcProvider.funcionarios.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: funcProvider.funcionarios.length,
                    itemBuilder: (context, index) {
                      final funcionario = funcProvider.funcionarios[index];
                      return ListTile(
                          title: Text(
                            funcionario.nome,
                            style: TextStyle(color: branco),
                          ),
                          subtitle: Text(
                            "${funcionario.email} ${funcionario.funcionarioId}",
                            style: const TextStyle(color: Colors.white38),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CadastrarFunc(
                                            funcionario: funcionario),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () async {
                                    // Exibe a confirmação antes de excluir
                                    bool? confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirmar Exclusão'),
                                        content: Text(
                                            'Tem certeza de que deseja excluir o funcionário ${funcionario.nome}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text('Confirmar'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await funcProvider.deletarFuncionario(
                                          funcionario.funcionarioId as int);
                                    }

                                    showMessage(
                                        message: funcProvider.menssagem,
                                        context: context);
                                    Navigator.of(context).pushNamed('/exibirfuncionarios');
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ));
                    },
                  ),
                );
              },
            ),
          ),
        ));
  }
}
