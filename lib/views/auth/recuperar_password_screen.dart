import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() => _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailEnviado = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleRecuperar() async {
    if (_formKey.currentState!.validate()) {
      final authViewModel = context.read<AuthViewModel>();
      
      final success = await authViewModel.recuperarPassword(
        email: _emailController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        setState(() {
          _emailEnviado = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage ?? 'Error'),
            backgroundColor: Colors.red,
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
              child: _emailEnviado ? _buildExito() : _buildFormulario(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_reset,
              size: 40,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Recuperar Contraseña',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Te enviaremos instrucciones a tu correo',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Correo electrónico',
              prefixIcon: const Icon(Icons.email_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (v) => v!.isEmpty || !v.contains('@') 
                ? 'Correo inválido' : null,
          ),
          const SizedBox(height: 24),
          
          Consumer<AuthViewModel>(
            builder: (context, auth, _) => CustomButton(
              text: 'Enviar Instrucciones',
              onPressed: _handleRecuperar,
              isLoading: auth.isLoading,
              icon: Icons.send,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExito() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            size: 60,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '¡Correo Enviado!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Enviamos las instrucciones a:',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          _emailController.text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Revisa tu bandeja de entrada y spam',
                  style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        CustomButton(
          text: 'Volver al Login',
          onPressed: () => Navigator.pop(context),
          icon: Icons.arrow_back,
        ),
      ],
    );
  }
}