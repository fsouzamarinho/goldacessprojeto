class Funcionarios {
  int? funcionarioId;
  String nome;
  String email;
  String cpf;
  String rfid;
  String password;
  String telefone;
  String cargo;
  String turno;

  Funcionarios({
    this.funcionarioId,
    required this.nome,
    required this.email,
    required this.cpf,
    required this.rfid,
    required this.password,
    required this.telefone,
    required this.cargo,
    required this.turno,
  });

  Map<String, dynamic> toJson() {
    return {
      'funcionarioId': funcionarioId ?? 0,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'rfid': rfid,
      'password': password,
      'telefone': telefone,
      'cargo': cargo,
      'turno': turno,
    };
  }

  factory Funcionarios.fromJson(Map<String, dynamic> json) {
    return Funcionarios(
      funcionarioId: json['funcionarioId'],
      nome: json['nome'],
      email: json['email'],
      cpf: json['cpf'],
      rfid: json['rfid'],
      password: json['password'],
      telefone: json['telefone'],
      cargo: json['cargo'],
      turno: json['turno'],
    );
  }
}