class Aditivo {
  final int id;
  final String nombre;
  final double precioExtra;

  Aditivo({
    required this.id,
    required this.nombre,
    required this.precioExtra,
  });

  factory Aditivo.fromJson(Map<String, dynamic> json) => Aditivo(
        id: json['id'] as int,
        nombre: json['nombre'] as String,
        precioExtra:
            (json['precio_extra'] ?? json['precioExtra'] as num).toDouble(),
      );
}
