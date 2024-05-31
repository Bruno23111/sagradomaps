import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class BlocosController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  double altitude = 0.0;
  String erro = '';

  Timer? _updateTimer;
  bool _disposed = false;

  BlocosController() {
    startLocationUpdates();
  }

  @override
  void dispose() {
    _disposed = true;
    _updateTimer?.cancel();
    super.dispose();
  }

  void startLocationUpdates() {
    const Duration updateInterval = Duration(seconds: 1);
    _updateTimer = Timer.periodic(updateInterval, (timer) {
      if (!_disposed) {
        getPosicao();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> getPosicao() async {
    try {
      Position posicao = await _posicaoAtual();
      lat = posicao.latitude;
      long = posicao.longitude;
      altitude = posicao.altitude;
      if (!_disposed) {
        notifyListeners();
      }
    } catch (e) {
      erro = e.toString();
      if (!_disposed) {
        notifyListeners();
      }
    }
  }

  Future<Position> _posicaoAtual() async {
    try {
      LocationPermission permissao;
      bool ativado = await Geolocator.isLocationServiceEnabled();

      if (!ativado) {
        erro = ('Por favor, habilite a localização!');
      }

      permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
        if (permissao == LocationPermission.denied) {
          erro = ('Você precisa autorizar o acesso à localização');
        }
      }

      if (permissao == LocationPermission.deniedForever) {
        erro = ('Você precisa autorizar o acesso à localização');
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      throw Exception('Erro ao obter a localização: $e');
    }
  }
}
