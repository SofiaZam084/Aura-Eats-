import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';
import 'registro_screen.dart';
import 'recuperar_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = context.read<AuthViewModel>();
      
      final success = await authViewModel.iniciarSesion(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Bienvenido de vuelta! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
      ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('¡Bienvenido de vuelta! 🎉'),
    backgroundColor: Color(0xFF0A3323),
    duration: Duration(seconds: 2),
    behavior: SnackBarBehavior.floating, 
  ),
);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Logo
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('🥗', style: TextStyle(fontSize: 50)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'AuraEats',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 48),
                    
                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v!.isEmpty || !v.contains('@') 
                          ? 'Correo inválido' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword 
                              ? Icons.visibility_outlined 
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => 
                              _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v!.length < 6 
                          ? 'Mínimo 6 caracteres' : null,
                    ),
                    const SizedBox(height: 12),
                    
                    // Recuperar
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => 
                                const RecuperarPasswordScreen())),
                        child: const Text('¿Olvidaste tu contraseña?'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Botón
                    Consumer<AuthViewModel>(
                      builder: (context, auth, _) => CustomButton(
                        text: 'Iniciar Sesión',
                        onPressed: _handleLogin,
                        isLoading: auth.isLoading,
                        icon: Icons.login,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Registro
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿No tienes cuenta? '),
                        TextButton(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => 
                                  const RegistroScreen())),
                          child: const Text('Regístrate'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}