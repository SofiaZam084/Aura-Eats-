import 'package:flutter/foundation.dart';
import '../models/carrito_item.dart';
import '../models/producto.dart';
import 'package:uuid/uuid.dart';

class CarritoViewModel extends ChangeNotifier {
  final List<CarritoItem> _items = [];
  final Uuid _uuid = const Uuid();

  // Getters
  List<CarritoItem> get items => _items;
  int get cantidadTotal => _items.fold(0, (sum, item) => sum + item.cantidad);
  double get total => _items.fold(0, (sum, item) => sum + item.subtotal);
  bool get estaVacio => _items.isEmpty;

  // RF7: Agregar al carrito
  void agregarProducto(
    Producto producto, {
    int cantidad = 1,
    List<Map<String, dynamic>> extras = const [],
    String? notas,
  }) {
    // Verificar si ya existe el mismo producto con los mismos extras
    final existeIndex = _items.indexWhere((item) =>
        item.producto.id == producto.id &&
        _compararExtras(item.extras, extras));

    if (existeIndex != -1) {
      // Incrementar cantidad
      _items[existeIndex].cantidad += cantidad;
    } else {
      // Agregar nuevo item
      _items.add(CarritoItem(
        id: _uuid.v4(),
        producto: producto,
        cantidad: cantidad,
        extras: extras,
        notasEspeciales: notas,
      ));
    }

    notifyListeners();
  }

  // RF8: Actualizar cantidad
  void actualizarCantidad(String itemId, int nuevaCantidad) {
    if (nuevaCantidad <= 0) {
      eliminarItem(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _items[index].cantidad = nuevaCantidad;
      notifyListeners();
    }
  }

  // RF8: Eliminar del carrito
  void eliminarItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  // Limpiar carrito
  void limpiarCarrito() {
    _items.clear();
    notifyListeners();
  }

  // Incrementar cantidad
  void incrementarCantidad(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      _items[index].cantidad++;
      notifyListeners();
    }
  }

  // Decrementar cantidad
  void decrementarCantidad(String itemId) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      if (_items[index].cantidad > 1) {
        _items[index].cantidad--;
        notifyListeners();
      } else {
        eliminarItem(itemId);
      }
    }
  }

  // Comparar extras
  bool _compararExtras(
    List<Map<String, dynamic>> extras1,
    List<Map<String, dynamic>> extras2,
  ) {
    if (extras1.length != extras2.length) return false;
    
    for (var i = 0; i < extras1.length; i++) {
      if (extras1[i]['nombre'] != extras2[i]['nombre']) return false;
      if (extras1[i]['cantidad'] != extras2[i]['cantidad']) return false;
    }
    
    return true;
  }
}