import 'package:flutter/foundation.dart';
import '../models/producto.dart';
import '../services/api_service.dart';

class ProductoProvider extends ChangeNotifier {
  List<Producto> _productos = [];
  bool _loading = false;
  String? _error;

  List<Producto> get productos => _productos;
  bool get loading => _loading;
  String? get error => _error;

  ProductoProvider() {
    loadProductos();
  }

  Future<void> loadProductos() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _productos = await ApiService.fetchProductos();
    } catch (e) {
      _error = e.toString();
    }
    _loading = false;
    notifyListeners();
  }
}
