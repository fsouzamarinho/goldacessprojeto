import 'package:flutter/material.dart';
import 'package:goldsecurity/Provider/FuncionarioSala/funcsalap.dart';
import 'package:goldsecurity/Style/colors.dart';
import 'package:goldsecurity/Telas/FuncionarioSala/associar.dart';
import 'package:provider/provider.dart';

class FuncSala extends StatefulWidget {
  final int? salaescolhida;
  const FuncSala({super.key, this.salaescolhida});

  @override
  State<FuncSala> createState() => _FuncSalaState();
}

class _FuncSalaState extends State<FuncSala> {
  @override
  void initState() {
    super.initState();
    Provider.of<FuncSalaProvider>(context, listen: false)
        .fetchSalas(widget.salaescolhida as int);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssociarFuncionarioSala(
                          salaId: widget.salaescolhida as int),
                    ),
                  );
                },
                child: Text(
                  "Adicionar Funcionário",
                  style: TextStyle(color: branco),
                )),
          ],
          title:
              Text("Funcionarios nas Salas", style: TextStyle(color: branco)),
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [primaryColor, Colors.white])),
                child: Consumer<FuncSalaProvider>(
                  builder: (context, salaProvider, child) {
                    if (salaProvider.funcionarios.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                              child: Text("Nenhum Funcionário Cadastrado")),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AssociarFuncionarioSala(
                                            salaId:
                                                widget.salaescolhida as int),
                                  ),
                                );
                              },
                              child: const Text("Adicionar Funcionário")),
                        ],
                      );
                    }
                    return Expanded(
                      child: ListView.builder(
                        itemCount: salaProvider.funcionarios.length,
                        itemBuilder: (context, index) {
                          final funcionario = salaProvider.funcionarios[index];
                          return ListTile(
                              title: Text(funcionario.nome, style: TextStyle(color: branco)),
                              subtitle: Text(funcionario.email, style: const TextStyle(color: Colors.white38),),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Confirmação'),
                                            content: const Text(
                                                'Tem certeza que deseja excluir este funcionário?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: const Text('Cancelar'),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, true),
                                                child: const Text('Confirmar'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          await Provider.of<FuncSalaProvider>(
                                                  context,
                                                  listen: false)
                                              .deletarFuncionario(funcionario
                                                  .funcionarioId as int, widget.salaescolhida as int );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(context
                                                    .read<FuncSalaProvider>()
                                                    .menssagem)),
                                          );
                                        }
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
              TextButton(
                  onPressed: () {}, child: const Text("Adicionar Funcionário")),
            ],
          ),
        ));
  }
}
