class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precioBase;
  final String imageUrl;
  final String categoria;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precioBase,
    required this.imageUrl,
    required this.categoria,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    final precioRaw = json['precio_base'] ?? json['precioBase'];
    final imageRaw = json['image_url'] ?? json['imageUrl'];
    final categoriaRaw = json['categoria'] ?? json['categoriaProducto'];
    if (precioRaw == null) {
      throw FormatException("precioBase no encontrado en JSON: $json");
    }
    if (categoriaRaw == null) {
      throw FormatException("categoria no encontrada en JSON: $json");
    }

    return Producto(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      descripcion: (json['descripcion'] as String?) ?? '',
      precioBase: (precioRaw as num).toDouble(),
      imageUrl: (imageRaw as String?) ?? '',
      categoria: categoriaRaw as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
        'precio_base': precioBase,
        'image_url': imageUrl,
        'categoria': categoria,
      };
}
