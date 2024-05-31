import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sagradomaps/components/block.dart';
import 'package:sagradomaps/components/location.dart';
import 'package:sagradomaps/models/evento.dart';

class ListaBloco extends StatefulWidget {
  final String letraBloco;
  final String nomeBloco;
  final int idBloco;

  const ListaBloco(this.idBloco, this.letraBloco, this.nomeBloco, {super.key});

  @override
  State<ListaBloco> createState() => _ListaBlocoState();
}

class _ListaBlocoState extends State<ListaBloco> {
  List<Eventos> listaEventos = [];
  FirebaseFirestore dataBase = FirebaseFirestore.instance;

  @override
  void initState() {
    refresh();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.red,
      ),
      child: TextButton(
        onPressed: () {
          refresh();
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13.0),
                        topRight: Radius.circular(13.0)),
                    color: Color.fromARGB(252, 227, 193, 146)
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Block(widget.nomeBloco),
                          (listaEventos.isEmpty)
          ? Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Color(0xFF7D0A0A),
              ),
              child: const Center(
                  child: Text(
                    "Nenhum evento nessse bloco no momento\nFique de olho!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Inter',),
                  ),
                ),
            ),
          )
          : RefreshIndicator(
              onRefresh: () {
                return refresh();
              },
              child: ListBody(
                children: List.generate(
                  listaEventos.length,
                  (index) {
                    Eventos model = listaEventos[index];
                    return Location(model.nome, model.descricaoSala, evento: model, idBloco: widget.idBloco,);
                  },
                ),
              ),
            ),
                        ]),
                  ),
                );
              });
        },
        child: selecionaIconeBloco(widget.idBloco),
      ),
    );
  }

  refresh() async {
  List<Eventos> temp = [];

  // Primeiro, vamos encontrar o documento na coleção "Blocos" com o nome do bloco
  QuerySnapshot<Map<String, dynamic>> blocosSnapshot = await dataBase
      .collection("Blocos")
      .where("nome", isEqualTo: widget.nomeBloco)
      .get();

  if (blocosSnapshot.docs.isNotEmpty) {
    String blocoId = blocosSnapshot.docs[0].id;

    // Agora, usando o ID do bloco, podemos acessar a subcoleção "eventos"
    QuerySnapshot<Map<String, dynamic>> eventosSnapshot = await dataBase
        .collection("Blocos")
        .doc(blocoId)
        .collection("eventos")
        .get();

    // Convertendo os documentos de eventos em objetos Eventos e adicionando à lista temporária
    temp = eventosSnapshot.docs.map((doc) => Eventos.fromMap(doc.data())).toList();
  }

  setState(() {
    listaEventos = temp;
  });
}


  Widget selecionaIconeBloco(int bloco) {
    if (bloco == 20) {
      return ClipRRect(
        child: Image.asset(
          'assets/images/lanchonete.png',
          fit: BoxFit.contain,
        ),
      );
    }

    if (bloco == 21) {
      return const Center(
        child: Icon(
          Icons.settings,
          color: Colors.white,
        ),
      );
    }

    return Text(
      widget.letraBloco,
      style: const TextStyle(color: Colors.white, fontFamily: 'Inter'),
    );
  }


}
