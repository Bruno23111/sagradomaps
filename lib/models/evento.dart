class Eventos {
  String id;
  String nome;
  String descricaoSala;
  double lat;
  double long;

  Eventos({
    required this.id,
    required this.nome,
    required this.descricaoSala,
    required this.lat,
    required this.long,
  });

  Eventos.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        nome = map["nome"],
        descricaoSala = map["descricaoSala"],
        lat = map["latitude"],
        long = map["longitude"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nome": nome,
      "descricaoSala": descricaoSala,
      "latitude": lat,
      "longitude": long,
    };
  }
}
