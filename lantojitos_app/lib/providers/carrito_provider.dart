import 'package:flutter/foundation.dart';
import '../models/producto.dart';
import '../models/aditivo.dart';

class CarritoItem {
  final Producto producto;
  int cantidad;
  final List<Aditivo> seleccionados;

  CarritoItem({
    required this.producto,
    this.cantidad = 1,
    this.seleccionados = const [],
  });

  double get total {
    final extras = seleccionados.fold<double>(
      0,
      (sum, a) => sum + a.precioExtra,
    );
    return (producto.precioBase + extras) * cantidad;
  }
}

class CarritoProvider extends ChangeNotifier {
  final List<CarritoItem> _items = [];

  List<CarritoItem> get items => List.unmodifiable(_items);
  double get total => _items.fold<double>(0, (sum, it) => sum + it.total);

  void addProducto(Producto p, {List<Aditivo> extras = const []}) {
    final idx = _items.indexWhere((it) =>
        it.producto.id == p.id && _listEqualsById(it.seleccionados, extras));
    if (idx >= 0) {
      _items[idx].cantidad++;
    } else {
      _items.add(CarritoItem(producto: p, seleccionados: extras));
    }
    notifyListeners();
  }

  bool _listEqualsById(List<Aditivo> a, List<Aditivo> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  void removeProducto(CarritoItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
