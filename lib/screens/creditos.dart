import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditosScreen extends StatefulWidget {
  const CreditosScreen({super.key});

  @override
  State<CreditosScreen> createState() => _BlocoScreenState();
}

class _BlocoScreenState extends State<CreditosScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('SagradoMaps',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          backgroundColor: const Color(0xFFBF3131),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width * 1,
          color: Colors.red,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1,
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    const Text(
                      'Disciplina:',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(''),
                    const Text(
                      'Desenvolvimento de Software',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(''),
                    const Text(
                      'Desenvolvedores:',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(''),
                    const Text(
                      'Bruno Bomfim Lima',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Guilherme Tamelini Bertozzo',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Pedro Lucas Franco',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Pedro Marques Correa Domingues',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Yago da Silva Leme',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(''),
                    const Text(
                      'Orientador:',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(''),
                    const Text(
                      'Prof. Dr. Elvio Gilberto da Silva',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(''),
                    const Text(
                      'Colaboradores:',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(''),
                    const Text(
                      'Design: Luiz Eduardo de Freitas Ernesto',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    const Text(''),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/images/Ciencia_da_Computacao.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text(''),
                    const Text(
                      'Apoio:',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ClipRRect(
                        child: Image.asset(
                          'assets/images/coordenadoria-de-extensao.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
