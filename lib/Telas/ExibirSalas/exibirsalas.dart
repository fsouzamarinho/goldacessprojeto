import 'package:flutter/material.dart';
import 'package:goldsecurity/Provider/Salas/salas.dart';
import 'package:goldsecurity/Style/colors.dart';
import 'package:goldsecurity/Telas/CadastrarSalas/cadastrarsalas.dart';
import 'package:goldsecurity/Telas/FuncionarioSala/funcsala.dart';
import 'package:goldsecurity/Utils/msg.dart';
import 'package:provider/provider.dart';

class ExibirSalas extends StatefulWidget {

  const ExibirSalas({super.key});

  @override
  State<ExibirSalas> createState() => _ExibirSalasState();
}

class _ExibirSalasState extends State<ExibirSalas> {

  @override
  void initState() {
    super.initState();
    Provider.of<AmbienteProvider>(context, listen: false).fetchAmbientes();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
          actions: [TextButton(onPressed: (){ Navigator.pushNamed(context, '/cadastrarsalas');}, child: Text(
                  "+ Salas",
                  style: TextStyle(
                    color: branco,
                    fontWeight: FontWeight.w600,
                  ),
                )
                )
                ],
          title: Text("Funcionarios nas Salas", style: TextStyle(color: branco)),
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
          child:Consumer<AmbienteProvider>(
        builder: (context, ambienteProvider, child) {
          if (ambienteProvider.ambientes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Expanded(
            child: ListView.builder(
              itemCount: ambienteProvider.ambientes.length,
              itemBuilder: (context, index) {
                final ambiente = ambienteProvider.ambientes[index];
                return ListTile(
                  onTap: (){
                     Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FuncSala(
                                            salaescolhida: ambiente.salaId),
                                      ),
                                    );
                  },
                  title: Text(ambiente.nomeSala, style: TextStyle(color: branco),),
                  subtitle: ambiente.acionado ? const Text('Aberto', style: TextStyle(color: Colors.white38)): const Text('fechado', style: TextStyle(color: Colors.white38)),
                  trailing:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(onPressed: (){
                        Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CadastrarSalas(
                                            ambiente: ambiente),
                                      ),
                                    );

                      }, icon: const Icon(Icons.edit,)),
                      IconButton(onPressed: () async{

                           // Exibe a confirmação antes de excluir
                                    bool? confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Confirmar Exclusão'),
                                        content: Text(
                                            'Tem certeza de que deseja excluir a sala: ${ambiente.nomeSala}?'),
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
                                      await  ambienteProvider.deletarSala(
                                              ambiente.salaId as int);
                                       // ignore: use_build_context_synchronously
                                     showMessage(message: ambienteProvider.menssagem, context: context);
                            
                                    }

                      }, icon: const Icon(Icons.delete)),
                    ],
                  )
                );
              },
            ),
          );
        },
      ),
                ),
        )
    );
  }
}