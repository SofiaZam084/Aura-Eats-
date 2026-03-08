import 'producto.dart';

class CarritoItem {
  final String id;
  final Producto producto;
  int cantidad;
  final List<Map<String, dynamic>> extras;
  final String? notasEspeciales;

  CarritoItem({
    required this.id,
    required this.producto,
    required this.cantidad,
    this.extras = const [],
    this.notasEspeciales,
  });

  double get subtotal {
    double precioBase = producto.precio * cantidad;
    double precioExtras = extras.fold(
      0, 
      (sum, extra) => sum + ((extra['precio'] ?? 0) * cantidad)
    );
    return precioBase + precioExtras;
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'producto': producto.toJson(),
      'cantidad': cantidad,
      'extras': extras,
      'notasEspeciales': notasEspeciales,
    };
  }
   factory CarritoItem.fromJson(Map<String, dynamic> json) {
    return CarritoItem(
      id: json['id'] as String,
      producto: Producto.fromJson(json['producto'] as Map<String, dynamic>),
      cantidad: json['cantidad'] as int,
      extras: (json['extras'] as List?)
              ?.map((e) => e as Map<String, dynamic>)
              .toList() ??
          [],
      notasEspeciales: json['notasEspeciales'] as String?,
    );
  }
}