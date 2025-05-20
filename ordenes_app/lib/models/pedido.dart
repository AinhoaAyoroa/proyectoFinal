import 'detalle_pedido.dart';

class Pedido {
  final int id;
  final DateTime fecha;
  String estado;
  final double precioTotal;
  final List<DetallePedido> detalles;

  Pedido({
    required this.id,
    required this.fecha,
    required this.estado,
    required this.precioTotal,
    required this.detalles,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        id: json['id'] as int,
        fecha: DateTime.parse(json['fecha'] as String),
        precioTotal:
            ((json['precio_total'] ?? json['precioTotal']) as num).toDouble(),
        estado: json['estado'] as String,
        detalles: (json['detalles'] as List<dynamic>?)
                ?.map((d) => DetallePedido.fromJson(d as Map<String, dynamic>))
                .toList() ??
            [],
      );
}
