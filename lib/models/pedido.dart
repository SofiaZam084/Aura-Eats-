import 'carrito_item.dart';

class Pedido {
  final String id;
  final String usuarioId;
  final List<CarritoItem> items;
  final double total;
  final String estado;
  final String metodoPago;
  final DateTime fechaCreacion;
  final String? direccionEntrega;
  final String? telefonoContacto;

  Pedido({
    required this.id,
    required this.usuarioId,
    required this.items,
    required this.total,
    required this.estado,
    required this.metodoPago,
    required this.fechaCreacion,
    this.direccionEntrega,
    this.telefonoContacto,
  });

  String get estadoEmoji {
    switch (estado) {
      case 'pendiente':
        return '🧾';
      case 'preparacion':
        return '🍳';
      case 'en_camino':
        return '🚴';
      case 'entregado':
        return '✅';
      case 'cancelado':
        return '❌';
      default:
        return '📦';
    }
  }

  String get estadoDescripcion {
    switch (estado) {
      case 'pendiente':
        return 'Pendiente';
      case 'preparacion':
        return 'En preparación';
      case 'en_camino':
        return 'En camino';
      case 'entregado':
        return 'Entregado';
      case 'cancelado':
        return 'Cancelado';
      default:
        return 'Desconocido';
    }
  }

   factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] as String,
      usuarioId: json['usuarioId'] as String,
      items: (json['items'] as List)
          .map((item) => CarritoItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      estado: json['estado'] as String,
      metodoPago: json['metodoPago'] as String,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      direccionEntrega: json['direccionEntrega'] as String?,
      telefonoContacto: json['telefonoContacto'] as String?,
    );
  }
Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuarioId': usuarioId,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'estado': estado,
      'metodoPago': metodoPago,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'direccionEntrega': direccionEntrega,
      'telefonoContacto': telefonoContacto,
    };
}
}