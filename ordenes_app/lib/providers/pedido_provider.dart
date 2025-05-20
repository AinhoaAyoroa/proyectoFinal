// lib/providers/pedido_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/pedido.dart';
import '../services/api_service.dart';

class PedidoProvider extends ChangeNotifier {
  List<Pedido> _pedidos = [];
  bool _loading = false;
  String? _error;
  Timer? _timer;

  List<Pedido> get pedidos => _pedidos;
  bool get loading => _loading;
  String? get error => _error;

  PedidoProvider() {
    fetchPedidos();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) => fetchPedidos());
  }

  Future<void> fetchPedidos() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _pedidos = await ApiService.fetchPendingPedidos();
    } catch (e) {
      _pedidos = [];
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> finalize(int pedidoId) async {
    await ApiService.finalizePedido(pedidoId);
    await fetchPedidos();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
