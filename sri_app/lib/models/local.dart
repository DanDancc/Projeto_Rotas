class Local {
  int? id;
  String nome;
  String endereco;
  double latitude;
  double longitude;
  String? descricao;
  DateTime dataCriacao;
  bool favorito;

  Local({
    this.id,
    required this.nome,
    required this.endereco,
    required this.latitude,
    required this.longitude,
    this.descricao,
    DateTime? dataCriacao,
    this.favorito = false,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'endereco': endereco,
      'latitude': latitude,
      'longitude': longitude,
      'descricao': descricao,
      'dataCriacao': dataCriacao.toIso8601String(),
      'favorito': favorito ? 1 : 0,
    };
  }

  factory Local.fromMap(Map<String, dynamic> map) {
    return Local(
      id: map['id'],
      nome: map['nome'],
      endereco: map['endereco'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      descricao: map['descricao'],
      dataCriacao: DateTime.parse(map['dataCriacao']),
      favorito: map['favorito'] == 1,
    );
  }

  @override
  String toString() {
    return 'Local{id: $id, nome: $nome, endereco: $endereco}';
  }
}