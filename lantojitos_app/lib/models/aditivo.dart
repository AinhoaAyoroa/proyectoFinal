class Aditivo {
  final int id;
  final String nombre;
  final String tipo;
  final double precioExtra;

  Aditivo({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.precioExtra,
  });

  factory Aditivo.fromJson(Map<String, dynamic> json) {
    final extraRaw = json['precio_extra'] ?? json['precioExtra'];
    if (extraRaw == null) {
      throw FormatException("precioExtra no encontrado en JSON: $json");
    }

    return Aditivo(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String,
      precioExtra: (extraRaw as num).toDouble(),
    );
  }
}
