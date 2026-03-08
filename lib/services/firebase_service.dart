import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // RF1: Registrar usuario
  /// Registra un nuevo usuario y guarda sus datos en Firestore.
  ///
  /// Devuelve un mapa con las claves siguientes:
  /// * `success` (bool) – indica si la operación fue exitosa.
  /// * `usuario` (Usuario) – sólo presente cuando `success` es true.
  /// * `mensaje` (String) – texto del error cuando falla.
  Future<Map<String, dynamic>> registrarUsuario({
    required String email,
    required String password,
    required String nombre,
  }) async {
    try {
      // Crear usuario en Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Crear documento en Firestore
      final usuario = Usuario(
        id: userCredential.user!.uid,
        nombre: nombre,
        email: email,
        fechaRegistro: DateTime.now(),
      );

      await _firestore.collection('usuarios').doc(usuario.id).set(usuario.toJson());

      return {
        'success': true,
        'usuario': usuario,
      };
    } catch (e) {
      print('Error en registro: $e');
      return {
        'success': false,
        'mensaje': e.toString(),
      };
    }
  }

  // RF2: Iniciar sesión
  Future<Map<String, dynamic>> iniciarSesion({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtener datos del usuario de Firestore
      DocumentSnapshot doc = await _firestore
          .collection('usuarios')
          .doc(userCredential.user!.uid)
          .get();

      if (doc.exists) {
        return {
          'success': true,
          'usuario': Usuario.fromJson(doc.data() as Map<String, dynamic>),
        };
      }

      return {
        'success': false,
        'mensaje': 'Usuario no encontrado en Firestore',
      };
    } catch (e) {
      print('Error en login: $e');
      return {
        'success': false,
        'mensaje': e.toString(),
      };
    }
  }

  // RF3: Recuperar contraseña
  Future<Map<String, dynamic>> recuperarPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
      };
    } catch (e) {
      print('Error en recuperación: $e');
      return {
        'success': false,
        'mensaje': e.toString(),
      };
    }
  }

  // Cerrar sesión
  Future<void> cerrarSesion() async {
    await _auth.signOut();
  }

  // Obtener usuario actual de Firebase Auth
  User? get usuarioActual => _auth.currentUser;

  /// Lee el documento del usuario actualmente autenticado en Firestore.
  ///
  /// Retorna `null` si no hay sesión iniciada o el documento no existe.
  Future<Usuario?> obtenerUsuarioActual() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc = await _firestore.collection('usuarios').doc(user.uid).get();
    if (doc.exists) {
      return Usuario.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Stream de cambios de autenticación
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}