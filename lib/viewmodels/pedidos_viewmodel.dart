import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pedido.dart';
import '../models/carrito_item.dart';
import '../services/pedidos_service.dart';
import 'package:uuid/uuid.dart';

class PedidosViewModel extends ChangeNotifier {
  final PedidosService _pedidosService = PedidosService();
  String? _currentUsuarioId; // used for caching key
  final Uuid _uuid = const Uuid();

  List<Pedido> _pedidos = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Pedido> get pedidos => _pedidos;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // RF10: Crear pedido
  Future<Pedido?> crearPedido({
    required String usuarioId,
    required List<CarritoItem> items,
    required double total,
    required String metodoPago,
    String? direccion,
    String? telefono,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pedido = Pedido(
        id: _uuid.v4(),
        usuarioId: usuarioId,
        items: items,
        total: total,
        estado: 'pendiente',
        metodoPago: metodoPago,
        fechaCreacion: DateTime.now(),
        direccionEntrega: direccion,
        telefonoContacto: telefono,
      );

      await _pedidosService.crearPedido(pedido);

      // keep a copy in memory so the UI updates immediately
      _pedidos.insert(0, pedido);

      // also refresh from backend to guarantee consistency and persist any
      // server-side defaults (e.g. timestamps). this makes sure the order
      // is both in Firestore and in our local list when the user reopens the
      // app.
      try {
        await cargarPedidos(pedido.usuarioId);
      } catch (_) {
        // ignore -- we already have the pedido inserted locally
      }
      
      // update cache after change
      _saveCachedPedidos();

      _isLoading = false;
      notifyListeners();
      
      return pedido;
    } catch (e) {
      _errorMessage = 'Error al crear pedido';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // RF12: Cargar pedidos del usuario
  Future<void> cargarPedidos(String usuarioId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _currentUsuarioId = usuarioId;

    // show cached orders first (if any) to give user immediate feedback
    final cached = await _loadCachedPedidos(usuarioId);
    if (cached != null && cached.isNotEmpty) {
      _pedidos = cached;
      notifyListeners();
    }

    try {
      _pedidos = await _pedidosService.obtenerPedidosUsuario(usuarioId);
      await _saveCachedPedidos();
    } catch (e) {
      // if network load fails, keep whatever we had, but report error
      _errorMessage = 'Error al cargar pedidos';
      if (kDebugMode) print('cargarPedidos error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // ---------------------------------------------
  // CACHING
  // ---------------------------------------------

  Future<void> _saveCachedPedidos() async {
    if (_currentUsuarioId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'pedidos_${_currentUsuarioId!}';
      final jsonString = jsonEncode(_pedidos.map((p) => p.toJson()).toList());
      await prefs.setString(key, jsonString);
    } catch (e) {
      if (kDebugMode) print('Error saving cached pedidos: $e');
    }
  }

  Future<List<Pedido>?> _loadCachedPedidos(String usuarioId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'pedidos_$usuarioId';
      final jsonString = prefs.getString(key);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List decoded = jsonDecode(jsonString) as List;
        return decoded
            .map((e) => Pedido.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      if (kDebugMode) print('Error loading cached pedidos: $e');
    }
    return null;
  }

  // Obtener pedido por ID
  Pedido? obtenerPedidoPorId(String pedidoId) {
    try {
      return _pedidos.firstWhere((p) => p.id == pedidoId);
    } catch (e) {
      return null;
    }
  }

  // Simular actualización de estado
  Future<void> actualizarEstadoPedido(String pedidoId, String nuevoEstado) async {
    final index = _pedidos.indexWhere((p) => p.id == pedidoId);
    if (index != -1) {
      await Future.delayed(const Duration(milliseconds: 500));
      notifyListeners();
    }
  }

  // Cancelar pedido
  Future<bool> cancelarPedido(String pedidoId) async {
    try {
      final index = _pedidos.indexWhere((p) => p.id == pedidoId);
      if (index != -1 && _pedidos[index].estado == 'pendiente') {
        await _pedidosService.cancelarPedido(pedidoId);
        await cargarPedidos(_pedidos[index].usuarioId);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = 'Error al cancelar pedido';
      notifyListeners();
      return false;
    }
  }
}