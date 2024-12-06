class Sala {
  int ? salaId;
  String nomeSala;
  bool acionado;

  Sala({this.salaId,required this.nomeSala, required this.acionado});

  Map<String, dynamic> toJson() {
    return {
      "salaId": salaId ?? 0,
      'nome': nomeSala,
      'acionado': false,
    };
  }

  factory Sala.fromJson(Map<String, dynamic> json) {
    return Sala(
      salaId: json['salaId'],
      nomeSala: json['nome'],
      acionado: json['acionado'],
    );
  }
  
}