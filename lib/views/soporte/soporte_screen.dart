import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SoporteScreen extends StatelessWidget {
  const SoporteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Soporte'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.support_agent,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '¿En qué podemos ayudarte?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Estamos disponibles 24/7',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // WhatsApp
            _buildOpcionContacto(
              icono: Icons.chat,
              iconoColor: const Color(0xFF25D366),
              titulo: 'WhatsApp',
              descripcion: 'Chatea con nosotros',
              onTap: () => _abrirWhatsApp(context),
            ),

            const SizedBox(height: 12),

            // Teléfono
            _buildOpcionContacto(
              icono: Icons.phone,
              iconoColor: Colors.blue,
              titulo: 'Llamar',
              descripcion: '+57 300 123 4567',
              onTap: () => _llamar(context),
            ),

            const SizedBox(height: 12),

            // Email
            _buildOpcionContacto(
              icono: Icons.email,
              iconoColor: Colors.orange,
              titulo: 'Email',
              descripcion: 'soporte@auraeats.com',
              onTap: () => _enviarEmail(context),
            ),

            const SizedBox(height: 32),

            // FAQ
            const Text(
              'Preguntas frecuentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildFAQ(
              pregunta: '¿Cuánto tiempo tarda la entrega?',
              respuesta: 'Normalmente entre 30-40 minutos, dependiendo de tu ubicación.',
            ),

            _buildFAQ(
              pregunta: '¿Puedo cancelar mi pedido?',
              respuesta: 'Sí, puedes cancelar tu pedido solo si está en estado "Pendiente".',
            ),

            _buildFAQ(
              pregunta: '¿Qué métodos de pago aceptan?',
              respuesta: 'Aceptamos efectivo, tarjeta (débito/crédito) y Nequi.',
            ),

            _buildFAQ(
              pregunta: '¿Tienen cobertura en mi zona?',
              respuesta: 'Contáctanos por WhatsApp con tu dirección y te confirmamos.',
            ),

            _buildFAQ(
              pregunta: '¿Los ingredientes son orgánicos?',
              respuesta: 'Sí, trabajamos con proveedores locales y productos orgánicos certificados.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpcionContacto({
    required IconData icono,
    required Color iconoColor,
    required String titulo,
    required String descripcion,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: iconoColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icono,
                color: iconoColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQ({
    required String pregunta,
    required String respuesta,
  }) {
    return ExpansionTile(
      title: Text(
        pregunta,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            respuesta,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _abrirWhatsApp(BuildContext context) async {
    final url = Uri.parse('https://wa.me/573001234567?text=Hola, necesito ayuda con mi pedido');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir WhatsApp'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _llamar(BuildContext context) async {
    final url = Uri.parse('tel:+573001234567');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo realizar la llamada'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _enviarEmail(BuildContext context) async {
    final url = Uri.parse('mailto:soporte@auraeats.com');
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el cliente de correo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}