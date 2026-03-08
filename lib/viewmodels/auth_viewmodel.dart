import 'package:flutter/foundation.dart';
import '../services/firebase_service.dart';
import '../models/usuario.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  Usuario? _usuarioActual;
  bool _isLoading = false;
  String? _errorMessage;

  Usuario? get usuarioActual => _usuarioActual;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _usuarioActual != null;

  AuthViewModel() {
    _initAuth();
  }

  Future<void> _initAuth() async {
    _firebaseService.authStateChanges.listen((user) async {
      if (user != null) {
        _usuarioActual = await _firebaseService.obtenerUsuarioActual();
      } else {
        _usuarioActual = null;
      }
      notifyListeners();
    });
  }

  Future<bool> registrar({
    required String email,
    required String password,
    required String nombre,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final resultado = await _firebaseService.registrarUsuario(
      email: email,
      password: password,
      nombre: nombre,
    );

    if (resultado['success'] == true) {
      _usuarioActual = resultado['usuario'] as Usuario?;
      _setLoading(false);
      return true;
    } else {
      _errorMessage = resultado['mensaje'] as String?;
      _setLoading(false);
      return false;
    }
  }

  Future<bool> iniciarSesion({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final resultado = await _firebaseService.iniciarSesion(
      email: email,
      password: password,
    );

    if (resultado['success'] == true) {
      _usuarioActual = resultado['usuario'] as Usuario?;
      _setLoading(false);
      return true;
    } else {
      _errorMessage = resultado['mensaje'] as String?;
      _setLoading(false);
      return false;
    }
  }

  Future<bool> recuperarPassword({
    required String email,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    final resultado = await _firebaseService.recuperarPassword(email: email);

    if (resultado['success'] == true) {
      _setLoading(false);
      return true;
    } else {
      _errorMessage = resultado['mensaje'] as String?;
      _setLoading(false);
      return false;
    }
  }

  Future<void> cerrarSesion() async {
    await _firebaseService.cerrarSesion();
    _usuarioActual = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}