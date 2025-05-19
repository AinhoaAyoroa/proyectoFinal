import 'package:flutter/foundation.dart';
import '../models/aditivo.dart';
import '../services/api_service.dart';

class AditivoProvider extends ChangeNotifier {
  List<Aditivo> _aditivos = [];
  bool _loading = false;

  List<Aditivo> get aditivos => _aditivos;
  bool get loading => _loading;

  AditivoProvider() {
    loadAditivos();
  }

  Future<void> loadAditivos() async {
    _loading = true;
    notifyListeners();
    try {
      _aditivos = await ApiService.fetchAditivos();
    } catch (_) {
      _aditivos = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  List<Aditivo> byTipo(String tipo) =>
      _aditivos.where((a) => a.tipo == tipo).toList();
}
