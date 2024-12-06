
class FuncionarioSala {
  int funcionarioSalaId;
  int funcionarioId;
  int salaId;

  FuncionarioSala({required this.funcionarioSalaId, required this.funcionarioId, required this.salaId});

  Map<String, dynamic> toJson() {
    return {
      "funcionarioSalaId": funcionarioSalaId,
      'funcionarioId': funcionarioId,
      'salaId': salaId,
    };
  }

  factory FuncionarioSala.fromJson(Map<String, dynamic> json) {
    return FuncionarioSala(
      funcionarioSalaId: json['funcionarioSalaId'], 
      funcionarioId: json['funcionarioId'], 
      salaId: json['salaId']); 
  }

}
