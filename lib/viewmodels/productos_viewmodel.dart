import 'package:flutter/foundation.dart';
import '../models/producto.dart';
import '../services/productos_service.dart';

class ProductosViewModel extends ChangeNotifier {
  final ProductosService _productosService = ProductosService();

  List<Producto> _productos = [];
  List<Producto> _productosFiltrados = [];
  String _categoriaSeleccionada = 'todos';
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Producto> get productos => _productosFiltrados;
  String get categoriaSeleccionada => _categoriaSeleccionada;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Categorías disponibles
  final List<Map<String, String>> categorias = [
    {'id': 'todos', 'nombre': 'Todos', 'emoji': '🍽️'},
    {'id': 'bowls', 'nombre': 'Bowls', 'emoji': '🥗'},
    {'id': 'ensaladas', 'nombre': 'Ensaladas', 'emoji': '🥬'},
    {'id': 'bebidas', 'nombre': 'Bebidas', 'emoji': '🥤'},
    {'id': 'postres', 'nombre': 'Postres', 'emoji': '🍰'},
  ];

  ProductosViewModel() {
    cargarProductos();
  }

  // RF4: Cargar productos por categoría
  Future<void> cargarProductos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _productos = await _productosService.obtenerProductos();
      _aplicarFiltros();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar productos';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cambiar categoría
  void cambiarCategoria(String categoria) {
    _categoriaSeleccionada = categoria;
    _aplicarFiltros();
    notifyListeners();
  }

  // RF6: Buscar productos
  void buscarProductos(String query) {
    if (query.isEmpty) {
      _productosFiltrados = _categoriaSeleccionada == 'todos'
          ? _productos
          : _productos
              .where((p) => p.categoria == _categoriaSeleccionada)
              .toList();
    } else {
      _productosFiltrados = _productos
          .where((p) =>
              p.nombre.toLowerCase().contains(query.toLowerCase()) ||
              p.descripcion.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (_categoriaSeleccionada != 'todos') {
        _productosFiltrados = _productosFiltrados
            .where((p) => p.categoria == _categoriaSeleccionada)
            .toList();
      }
    }
    notifyListeners();
  }

  // Aplicar filtros
  void _aplicarFiltros() {
    if (_categoriaSeleccionada == 'todos') {
      _productosFiltrados = List.from(_productos);
    } else {
      _productosFiltrados = _productos
          .where((p) => p.categoria == _categoriaSeleccionada)
          .toList();
    }
  }

  // Obtener producto por ID
  Producto? obtenerProductoPorId(String id) {
    try {
      return _productos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}