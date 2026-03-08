import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _aceptaTerminos = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistro() async {
    if (!_aceptaTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes aceptar los términos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      final authViewModel = context.read<AuthViewModel>();
      
      final success = await authViewModel.registrar(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        nombre: _nombreController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cuenta creada! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
       ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('¡Cuenta creada! 🎉'),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Crear Cuenta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Completa tus datos',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v!.length < 3 ? 'Mínimo 3 caracteres' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Correo',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => !v!.contains('@') ? 'Correo inválido' : null,
                    ),
                    const SizedBox(height: 16),
                    
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
                      validator: (v) => v!.length < 6 ? 'Mínimo 6 caracteres' : null,
                    ),
                    const SizedBox(height: 16),
                    
                    TextFormField(
                      controller: _confirmarPasswordController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        labelText: 'Confirmar',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm 
                              ? Icons.visibility_outlined 
                              : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => 
                              _obscureConfirm = !_obscureConfirm),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v != _passwordController.text 
                          ? 'No coinciden' : null,
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Checkbox(
                          value: _aceptaTerminos,
                          onChanged: (v) => setState(() => _aceptaTerminos = v!),
                          activeColor: const Color(0xFF4CAF50),
                        ),
                        const Expanded(
                          child: Text(
                            'Acepto los Términos y Condiciones',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    Consumer<AuthViewModel>(
                      builder: (context, auth, _) => CustomButton(
                        text: 'Crear Cuenta',
                        onPressed: _handleRegistro,
                        isLoading: auth.isLoading,
                        icon: Icons.person_add,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿Ya tienes cuenta? '),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Inicia sesión',
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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