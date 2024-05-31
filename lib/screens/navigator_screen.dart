import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sagradomaps/controllers/block_controller.dart';
import 'package:sagradomaps/models/evento.dart';

class Navegacao extends StatefulWidget {
  final int idBloco;
  final Eventos evento;

  const Navegacao({super.key, required this.evento, required this.idBloco});

  @override
  State<Navegacao> createState() => _NavegacaoState();
}

class _NavegacaoState extends State<Navegacao> {
  late BlocosController local;
  bool _calculatingRoute = false;
  List<LatLng> _currentMatrixPoints = [];
  bool _popupCloseShow = false;
  // ignore: non_constant_identifier_names
  double DISTANCE_LIMIT = 0.22;

  bool podeLigarDireto = true;

  final List<LatLng> pontosTerreo = [
    //Pontos entre a frente da faculdade e o bloco F
    const LatLng(-22.328361, -49.052479),
    const LatLng(-22.328588, -49.052431),
    const LatLng(-22.328878, -49.052304),
    const LatLng(-22.329150, -49.052178),
    const LatLng(-22.329293, -49.052171),
    const LatLng(-22.329401, -49.052116),
    //Caminho entre o F e J
    const LatLng(-22.329304, -49.0518722),
    const LatLng(-22.329466, -49.051850),
    const LatLng(-22.329460, -49.051755),
    const LatLng(-22.329545, -49.051842),
    const LatLng(-22.329982, -49.051685),
    //Ja no J
    //Ponto medio entre o J e K
    const LatLng(-22.330148, -49.051827),
    //Subida ate o O
    const LatLng(-22.330751, -49.051602),
    const LatLng(-22.331455598687093, -49.05188095423977),

    //Escada O grande
    const LatLng(-22.331431, -49.052096),
    //Esquina O
    const LatLng(-22.331676, -49.051986),
    //Escada O pequena
    const LatLng(-22.331567, -49.051621),
    //Escada l
    const LatLng(-22.331878, -49.051626),
    //Dentro do L
    const LatLng(-22.331775, -49.051277),
    const LatLng(-22.331687, -49.050944),
    const LatLng(-22.331521, -49.050941),
    //Esquina pra baixo do O:
    const LatLng(-22.330964, -49.052193),
    //Caminho F ate o j direita:
    const LatLng(-22.329461, -49.052649),
    //Esquina F:
    const LatLng(-22.329120, -49.052762),
    //Ponto medio F Direita:
    const LatLng(-22.329072, -49.052513),
    const LatLng(-22.32908727188267, -49.05226030222052),
    //pontos complementares
    const LatLng(-22.330575917216432, -49.0517775045934),
    const LatLng(-22.32791619306777, -49.05228175990117),
    const LatLng(-22.329722429183317, -49.05182041994895),
    const LatLng(-22.329772050724223, -49.05182041994895),
    const LatLng(-22.329851445152972, -49.05184187762162),
    const LatLng(-22.328789540924152, -49.05238904827364),
    //alguns pontos do j
    const LatLng(-22.330010233870244, -49.0517453180935),
    const LatLng(-22.329923529951436, -49.051846822056625),
    //a se pensar
    const LatLng(-22.33042958267197, -49.051935797895766),
    const LatLng(-22.331501398599762, -49.051817780695295),
    const LatLng(-22.33174305544832, -49.05153241726159),
    const LatLng(-22.330792135579703, -49.052209283052996),
    //const LatLng(-22.33094946425025, -49.05135524129347),
    const LatLng(-22.32895166514142, -49.052254897494024),

    //pontos adicionais A - F
    const LatLng(-22.328075378305293, -49.05270326626053),
    const LatLng(-22.328219282424342, -49.05262816441106),
    const LatLng(-22.328386, -49.052489),
    const LatLng(-22.328110002425127, -49.052563170318116),
    const LatLng(-22.32799090927837, -49.052659729838865),
    const LatLng(-22.328020, -49.052646),
    const LatLng(-22.32883460822086, -49.052381443001984),
    const LatLng(-22.32867853220883, -49.052381443001984),
    const LatLng(-22.32804003138215, -49.05250250085149),
    const LatLng(-22.328433991633347, -49.05307400578421),
    const LatLng(-22.329198474038737, -49.05224371405439),
    const LatLng(-22.329353780220448, -49.05203923887698),
    const LatLng(-22.329619036179768, -49.05181510105104),
    const LatLng(-22.33123920649063, -49.051464709176734),
    const LatLng(-22.328979, -49.052270),
    //Bloco O
    const LatLng(-22.331063, -49.051536),
    const LatLng(-22.331184, -49.051400),
    const LatLng(-22.330936, -49.051459),

    const LatLng(-22.330379, -49.051664),
    const LatLng(-22.330327, -49.051632),
    const LatLng(-22.329261, -49.052161),
    const LatLng(-22.329243, -49.052025),

    //rua
    const LatLng(-22.328747687737973, -49.052954955042146),
    const LatLng(-22.329020607901608, -49.05281548018872),
    const LatLng(-22.329402695233654, -49.052735013927126),
    const LatLng(-22.329417581731896, -49.0527189206748),
    const LatLng(-22.330072586082125, -49.05252580164697),
    const LatLng(-22.330386566576717, -49.05241287938316),
    const LatLng(-22.33076058150724, -49.05228708554935),

    //entre j e k
    const LatLng(-22.330196218793763, -49.0517471514398),
    const LatLng(-22.330296218461065, -49.05174525483182),

    //indo ate o O
    const LatLng(-22.330541831385748, -49.05165232099663),
    const LatLng(-22.33055411201547, -49.05163525155178),
    const LatLng(-22.33075060201773, -49.05154800758496),
    const LatLng(-22.330913758684282, -49.05152335168129),
    const LatLng(-22.331117265661387, -49.0514474873354),
    const LatLng(-22.33058939831084, -49.05153161157407),
    //bloco L
    const LatLng(-22.33151595806876, -49.05146387560156),
    const LatLng(-22.331673959500154, -49.05162340208807),

    const LatLng(-22.32843914336533, -49.052334613565165),
    const LatLng(-22.32872846641327, -49.05230617949416),

    const LatLng(-22.330419365186046, -49.051805678615175),
    const LatLng(-22.330331507863438, -49.05156837118199),
    const LatLng(-22.33034660206906, -49.051481342342825),
    const LatLng(-22.330286225236776, -49.051432388620796),
    const LatLng(-22.32924542443841, -49.05222054232958),
    
    //nepri
    const LatLng(-22.329836733820436, -49.051689257737195)
  ];

  @override
  void initState() {
    super.initState();
    local = BlocosController();
    _currentMatrixPoints = pontosTerreo;
    _calculatingRoute = true;
    _calculateRouteAndSetState();
    _showAlertPopup(); // Set the initial points
  }

  @override
  void dispose() {
    local.dispose(); // Dispose do BlocosController
    super.dispose();
  }

  void _calculateRouteAndSetState() async {
    // Simula um atraso de 2 segundos para calcular a rota
    await Future.delayed(const Duration(seconds: 2));

    // Quando o cálculo da rota estiver concluído, define _calculatingRoute como false
    if (mounted) {
      setState(() {
        _calculatingRoute = false;
      });
    }
  }

  void _showAlertPopup() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertDialog(
              title: Text("Atenção"),
              content: Text(
                "Fique atento ao andar em que está!",
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (local.erro == '') {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.evento.nome,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          backgroundColor: const Color(0xFFBF3131),
        ),
        body: ChangeNotifierProvider<BlocosController>(
          create: (context) => BlocosController(),
          child: Builder(
            builder: (context) {
              final local = context.watch<BlocosController>();
              return Stack(
                children: [
                  _calculatingRoute
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 20),
                              Text("Calculando rota..."),
                            ],
                          ),
                        )
                      : content(local),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _showPopup('Local em Rota');
                        });
                      },
                      child: const Icon(Icons.location_city),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.evento.nome,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          backgroundColor: const Color(0xFFBF3131),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.red,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Erro: ${local.erro}',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Inter'),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }


  Widget content(BlocosController local) {
    LatLng userLocation = LatLng(local.lat, local.long);

    double distanceToDestination = calculateDistance(
        userLocation, LatLng(widget.evento.lat, widget.evento.long));
    if (distanceToDestination <= 0.03 && !_popupCloseShow) {
      _popupCloseShow = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPopup('Você está chegando ao local');
      });
    }

    List<LatLng> routeCoordinates = calculateRoute(
      _currentMatrixPoints,
      userLocation,
      LatLng(widget.evento.lat, widget.evento.long),
    );

    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(-22.329846482986326, -49.05221202242119),
        initialZoom: 17,
        // ignore: deprecated_member_use
        rotation: 17.8,
        interactionOptions:
            InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
      ),
      children: [
        openStreetMapTileLayer,
        PolygonLayer(
          polygons: [
            Polygon(
              points: _currentMatrixPoints,
              color: Colors.blue.withOpacity(1),
            ),
          ],
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: routeCoordinates,
              color: Colors.blue,
              strokeWidth: 4,
            ),
          ],
        ),
        MarkerLayer(markers: [
          Marker(
              point: userLocation,
              alignment: Alignment.center,
              child: const Icon(
                Icons.circle,
                size: 20,
                color: Colors.red,
              )),
          Marker(
            point: LatLng(widget.evento.lat, widget.evento.long),
            alignment: Alignment.center,
            child: const Icon(
              Icons.location_pin,
              size: 45,
              color: Colors.red,
            ),
          )
        ])
      ],
    );
  }

  List<LatLng> calculateRoute(
      List<LatLng> matrixPoints, LatLng userLocation, LatLng endPoint) {
    // Verifica se a distância entre o usuário e o destino é menor que a distância limite
    double initialDistance = calculateDistance(userLocation, endPoint);
    if (initialDistance <= DISTANCE_LIMIT && podeLigarDireto) {
      return [userLocation, endPoint]; // Rota direta
    }

    Map<LatLng, Map<LatLng, double>> graph = {};

    // Adiciona todos os pontos da matriz, usuário e destino ao grafo
    for (var point in matrixPoints) {
      graph[point] = {};
    }
    graph[userLocation] = {};
    graph[endPoint] = {};

    // Calcula as distâncias entre todos os pontos da matriz e adiciona ao grafo
    for (int i = 0; i < matrixPoints.length; i++) {
      for (int j = i + 1; j < matrixPoints.length; j++) {
        double distance = calculateDistance(matrixPoints[i], matrixPoints[j]);
        graph[matrixPoints[i]]![matrixPoints[j]] = distance;
        graph[matrixPoints[j]]![matrixPoints[i]] = distance;
      }
    }

    // Calcula as distâncias entre o usuário e todos os pontos da matriz
    for (int i = 0; i < matrixPoints.length; i++) {
      double distance = calculateDistance(userLocation, matrixPoints[i]);
      graph[userLocation]![matrixPoints[i]] = distance;
      graph[matrixPoints[i]]![userLocation] = distance;
    }

    // Calcula as distâncias entre o destino e todos os pontos da matriz
    for (int i = 0; i < matrixPoints.length; i++) {
      double distance = calculateDistance(endPoint, matrixPoints[i]);
      graph[endPoint]![matrixPoints[i]] = distance;
      graph[matrixPoints[i]]![endPoint] = distance;
    }

    List<LatLng> routeCoordinates = [];
    LatLng currentPoint = userLocation;

    // Enquanto o ponto atual não for o ponto de destino, encontra o ponto mais próximo
    while (currentPoint != endPoint) {
      LatLng nearestPoint =
          _getNearestUnvisitedPoint(graph, currentPoint, routeCoordinates);

      // Adiciona o próximo trecho da rota até o próximo ponto mais próximo
      routeCoordinates.addAll(dijkstra(graph, currentPoint, nearestPoint));
      currentPoint = nearestPoint;
    }

    return routeCoordinates;
  }

  LatLng _getNearestUnvisitedPoint(Map<LatLng, Map<LatLng, double>> graph,
      LatLng currentPoint, List<LatLng> visitedPoints) {
    double minDistance = double.infinity;
    LatLng nearestPoint = currentPoint;

    // Encontra o ponto mais próximo não visitado do ponto atual
    graph[currentPoint]!.forEach((point, distance) {
      if (!visitedPoints.contains(point) && distance < minDistance) {
        minDistance = distance;
        nearestPoint = point;
      }
    });

    return nearestPoint;
  }

  List<LatLng> dijkstra(
      Map<LatLng, Map<LatLng, double>> graph, LatLng start, LatLng end) {
    Set<LatLng> visited = {};
    Map<LatLng, double> distances = {};
    Map<LatLng, LatLng> previous = {};
    List<LatLng> path = [];

    // Inicializa as distâncias
    for (var node in graph.keys) {
      distances[node] = double.infinity;
    }
    distances[start] = 0;

    while (visited.length < graph.length) {
      LatLng current = _getNodeWithMinDistance(distances, visited);
      visited.add(current);

      if (current == end) {
        while (previous.containsKey(current)) {
          path.insert(0, current);
          current = previous[current]!;
        }
        path.insert(0, start);
        break;
      }

      if (distances[current] == double.infinity) {
        break;
      }

      for (LatLng neighbor in graph[current]!.keys) {
        double tentativeDistance =
            distances[current]! + graph[current]![neighbor]!;
        if (tentativeDistance < distances[neighbor]!) {
          distances[neighbor] = tentativeDistance;
          previous[neighbor] = current;
        }
      }
    }

    return path;
  }

  LatLng _getNodeWithMinDistance(
      Map<LatLng, double> distances, Set<LatLng> visited) {
    LatLng minNode = const LatLng(0, 0);
    double minDistance = double.infinity;

    distances.forEach((node, distance) {
      if (distance < minDistance && !visited.contains(node)) {
        minNode = node;
        minDistance = distance;
      }
    });

    return minNode;
  }

  double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Raio da Terra em quilômetros
    double lat1 = point1.latitude;
    double lon1 = point1.longitude;
    double lat2 = point2.latitude;
    double lon2 = point2.longitude;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;
    return distance;
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void _showPopup(String informacoes) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0)),
                color: Color.fromARGB(252, 227, 193, 146)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    informacoes,
                    style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter'),
                  ),
                ),
                const Text(
                  'Fique atento(a) às Placas!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20.0),
                selecionaImagem(widget.idBloco),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget selecionaImagem(int idBloco) {
    switch (idBloco) {
      //Bloco A
      case 1:
        return Column(
          children: [
            Image.asset(
              'assets/images/BlocoA.jpg',
              height: MediaQuery.of(context).size.height * 0.42,
            ),
            Image.asset(
              'assets/images/FrenteAB.jpg',
              height: MediaQuery.of(context).size.height * 0.42,
            ),
          ],
        );
      //Bloco B
      case 2:
        return Column(
          children: [
            Image.asset(
              'assets/images/BlocoB.jpg',
              height: MediaQuery.of(context).size.height * 0.42,
            ),
            Image.asset(
              'assets/images/FrenteAB.jpg',
              height: MediaQuery.of(context).size.height * 0.42,
            ),
          ],
        );
      //Bloco C
      case 3:
        if (widget.evento.descricaoSala.contains("Térreo")) {
          return Column(
            children: [
              Image.asset(
                'assets/images/BlocoCDE.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/BlocoCDE2.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/unisagrado-store.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
            ],
          );
        } else {
          return Image.asset(
            'assets/images/1andarCDE.jpg',
            height: MediaQuery.of(context).size.height * 0.7,
          );
        }

      //Bloco D
      case 4:
        if (widget.evento.descricaoSala.contains("Térreo")) {
          return Column(
            children: [
              Image.asset(
                'assets/images/BlocoCDE.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/BlocoCDE2.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/unisagrado-store.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
            ],
          );
        } else {
          return Image.asset(
            'assets/images/1andarCDE.jpg',
            height: MediaQuery.of(context).size.height * 0.7,
          );
        }

      //Bloco E
      case 5:
        if (widget.evento.descricaoSala.contains("Térreo")) {
          return Column(
            children: [
              Image.asset(
                'assets/images/BlocoCDE.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/BlocoCDE2.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/unisagrado-store.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
            ],
          );
        } else {
          return Image.asset(
            'assets/images/1andarCDE.jpg',
            height: MediaQuery.of(context).size.height * 0.7,
          );
        }

      //Bloco F
      case 6:
        if (widget.evento.descricaoSala.contains("Térreo")) {
          return Column(
            children: [
              Image.asset(
                'assets/images/BlocoF-terreo.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/BlocoFG.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/BlocoFG-2.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
            ],
          );
        } else {
          return Image.asset(
            'assets/images/1andarFG.jpg',
            height: MediaQuery.of(context).size.height * 0.7,
          );
        }

      //Bloco G
      case 7:
        if (widget.evento.descricaoSala.contains("Térreo")) {
          return Column(
            children: [
              Image.asset(
                'assets/images/BlocoFG.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/BlocoFG-2.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/BlocoG-lado.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
            ],
          );
        } else {
          return Image.asset(
            'assets/images/1andarFG.jpg',
            height: MediaQuery.of(context).size.height * 0.7,
          );
        }

      //Bloco J
      case 8:
        if (widget.evento.descricaoSala.contains("Térreo")) {
          return Image.asset(
            'assets/images/BlocoJ.jpg',
            height: MediaQuery.of(context).size.height * 0.42,
          );
        } else if (widget.evento.descricaoSala.contains("1")) {
          return Image.asset(
            'assets/images/1andarJ.jpg',
            height: MediaQuery.of(context).size.height * 0.42,
          );
        } else if (widget.evento.descricaoSala.contains("2")) {
          return Image.asset(
            'assets/images/2andarJ.jpg',
            height: MediaQuery.of(context).size.height * 0.42,
          );
        } else {
          return Image.asset(
            'assets/images/3andarJ.jpg',
            height: MediaQuery.of(context).size.height * 0.7,
          );
        }

      //Bloco K
      case 9:
        if (widget.evento.descricaoSala.contains("2")) {
          return Image.asset(
            'assets/images/2andarK.jpg',
            height: MediaQuery.of(context).size.height * 0.42,
          );
        } else if (widget.evento.descricaoSala.contains("3")) {
          return Image.asset(
            'assets/images/3andarK.jpg',
            height: MediaQuery.of(context).size.height * 0.42,
          );
        } else {
          return Column(
            children: [
              Image.asset(
                'assets/images/BlocoK-frente.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/BlocoK-atras.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
            ],
          );
        }

      //Bloco O
      case 10:
        if (widget.evento.descricaoSala.contains("1")) {
          return Image.asset(
            'assets/images/1andarO.jpg',
            height: MediaQuery.of(context).size.height * 0.42,
          );
        } else {
          return Column(
            children: [
              Image.asset(
                'assets/images/BlocoO-frente.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/BlocoO-atras.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
            ],
          );
        }

      //Bloco L
      case 11:
        if (widget.evento.descricaoSala.contains("1")) {
          return Image.asset(
            'assets/images/1andarL.jpg',
            height: MediaQuery.of(context).size.height * 0.42,
          );
        } else {
          return Column(
            children: [
              Image.asset(
                'assets/images/BlocoL.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
              Image.asset(
                'assets/images/ExtraBlocoL.jpg',
                height: MediaQuery.of(context).size.height * 0.42,
              ),
            ],
          );
        }

      //Bloco Q - Nutricao
      case 12:
        return Image.asset(
          'assets/images/BlocoQ.jpg',
          height: MediaQuery.of(context).size.height * 0.42,
        );
      default:
        return const Text("Erro ao achar imagem...");
    }
  }
}

TileLayer get openStreetMapTileLayer {
  return TileLayer(
    urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
    userAgentPackageName: 'br.unisagrado',
  );
}
