class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precioBase;
  final String imageUrl;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precioBase,
    required this.imageUrl,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    final precioRaw = json['precio_base'] ?? json['precioBase'];
    final imageRaw = json['image_url'] ?? json['imageUrl'];

    if (precioRaw == null) {
      throw FormatException("precioBase no encontrado en JSON: $json");
    }

    return Producto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: (json['descripcion'] as String?) ?? '',
      precioBase: (precioRaw as num).toDouble(),
      imageUrl: (imageRaw as String?) ?? '',
    );
  }
}
