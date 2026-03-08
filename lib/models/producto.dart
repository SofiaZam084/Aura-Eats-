class Producto {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;
  final String imagenUrl;
  final List<String> ingredientes;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.imagenUrl,
    this.ingredientes = const [],
  });

Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'categoria': categoria,
      'imagenUrl': imagenUrl,
      'ingredientes': ingredientes,
    };
  }

factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      descripcion: json['descripcion'] as String,
      precio: (json['precio'] as num).toDouble(),
      categoria: json['categoria'] as String,
      imagenUrl: json['imagenUrl'] as String,
      ingredientes: (json['ingredientes'] as List?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
}
}