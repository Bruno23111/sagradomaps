import 'package:latlong2/latlong.dart';

class Rota {
  final String nome;
  final List<LatLng> pontos;

  Rota(this.nome, this.pontos);
}

// Definição das rotas predefinidas
final List<Rota> rotasPredefinidas = [
  Rota('Frente da Faculdade ao Bloco F', [
    const LatLng(-22.327934, -49.052631),
    const LatLng(-22.328361, -49.052479),
    // Adicione todos os pontos da rota
    // ...
    const LatLng(-22.329072, -49.052513),
  ]),
  // Defina outras rotas conforme necessário
];
