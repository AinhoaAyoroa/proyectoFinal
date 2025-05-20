import 'aditivo.dart';

class DetallePedido {
  final int id;
  final int cantidad;
  final double precio;
  final double costoExtra;
  final String productoNombre;
  final List<Aditivo> aditivos;

  DetallePedido({
    required this.id,
    required this.cantidad,
    required this.precio,
    required this.costoExtra,
    required this.productoNombre,
    required this.aditivos,
  });

  factory DetallePedido.fromJson(Map<String, dynamic> json) => DetallePedido(
        id: json['id'] as int,
        cantidad: json['cantidad'] as int,
        precio: (json['precio'] as num).toDouble(),
        costoExtra:
            ((json['costo_extra'] ?? json['costoExtra']) as num).toDouble(),
        productoNombre: (json['producto']?['nombre'] as String?) ?? '...',
        aditivos: (json['aditivos'] as List<dynamic>?)
                ?.map((a) => Aditivo.fromJson(a as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
