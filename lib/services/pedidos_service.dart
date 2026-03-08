import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/pedido.dart';

class PedidosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Crear pedido en Firestore
  Future<void> crearPedido(Pedido pedido) async {
    try {
      await _firestore.collection('pedidos').doc(pedido.id).set(pedido.toJson());
    } catch (e) {
      print('Error al crear pedido: $e');
      throw 'Error al guardar el pedido';
    }
  }

  // Obtener pedidos de un usuario
  Future<List<Pedido>> obtenerPedidosUsuario(String usuarioId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('pedidos')
          .where('usuarioId', isEqualTo: usuarioId)
          .orderBy('fechaCreacion', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Pedido.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error al obtener pedidos: $e');
      return [];
    }
  }

  // Obtener pedido por ID
  Future<Pedido?> obtenerPedidoPorId(String pedidoId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('pedidos')
          .doc(pedidoId)
          .get();

      if (doc.exists) {
        return Pedido.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error al obtener pedido: $e');
      return null;
    }
  }

  // Cancelar pedido
  Future<void> cancelarPedido(String pedidoId) async {
    try {
      await _firestore.collection('pedidos').doc(pedidoId).update({
        'estado': 'cancelado',
      });
    } catch (e) {
      print('Error al cancelar pedido: $e');
      throw 'Error al cancelar el pedido';
    }
  }

  // Actualizar estado del pedido
  Future<void> actualizarEstado(String pedidoId, String nuevoEstado) async {
    try {
      await _firestore.collection('pedidos').doc(pedidoId).update({
        'estado': nuevoEstado,
      });
    } catch (e) {
      print('Error al actualizar estado: $e');
      throw 'Error al actualizar el estado';
    }
  }

  // Stream de pedidos en tiempo real
  Stream<List<Pedido>> streamPedidosUsuario(String usuarioId) {
    return _firestore
        .collection('pedidos')
        .where('usuarioId', isEqualTo: usuarioId)
        .orderBy('fechaCreacion', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Pedido.fromJson(doc.data()))
            .toList());
  }
}