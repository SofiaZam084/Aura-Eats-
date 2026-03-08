import 'package:flutter/material.dart';
import '../../models/pedido.dart';

class SeguimientoScreen extends StatelessWidget {
  final Pedido pedido;

  const SeguimientoScreen({
    super.key,
    required this.pedido,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Seguimiento'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        pedido.estadoEmoji,
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pedido.estadoDescripcion,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pedido #${pedido.id.substring(0, 8).toUpperCase()}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text(
              'Estado del pedido',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            _buildTimeline(context),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tiempo estimado de entrega',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getTiempoEstimado(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (pedido.direccionEntrega != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dirección de entrega',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pedido.direccionEntrega!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.help_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¿Necesitas ayuda?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Contáctanos por WhatsApp',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _abrirWhatsApp(context),
                    icon: const Icon(
                      Icons.phone,
                      color: Color(0xFF25D366),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final estados = [
      {
        'estado': 'pendiente',
        'titulo': 'Pedido recibido',
        'descripcion': 'Tu pedido ha sido confirmado',
        'icono': Icons.receipt_long,
      },
      {
        'estado': 'preparacion',
        'titulo': 'En preparación',
        'descripcion': 'Estamos preparando tu pedido',
        'icono': Icons.restaurant,
      },
      {
        'estado': 'en_camino',
        'titulo': 'En camino',
        'descripcion': 'Tu pedido está en camino',
        'icono': Icons.delivery_dining,
      },
      {
        'estado': 'entregado',
        'titulo': 'Entregado',
        'descripcion': '¡Disfruta tu comida!',
        'icono': Icons.check_circle,
      },
    ];

    final estadoIndex = estados.indexWhere(
      (e) => e['estado'] == pedido.estado,
    );

    return Column(
      children: estados.asMap().entries.map((entry) {
        final index = entry.key;
        final estado = entry.value;
        final isActivo = index <= estadoIndex;
        final esActual = index == estadoIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActivo
                        ? const Color(0xFF4CAF50)
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    estado['icono'] as IconData,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (index < estados.length - 1)
                  Container(
                    width: 2,
                    height: 60,
                    color: isActivo
                        ? const Color(0xFF4CAF50)
                        : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      estado['titulo'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: esActual
                            ? FontWeight.bold
                            : FontWeight.w600,
                        color: isActivo ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      estado['descripcion'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: isActivo ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
                    if (esActual) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Estado actual',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF4CAF50),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _getTiempoEstimado() {
    switch (pedido.estado) {
      case 'pendiente':
        return '30-40 minutos';
      case 'preparacion':
        return '20-30 minutos';
      case 'en_camino':
        return '10-15 minutos';
      case 'entregado':
        return 'Pedido entregado';
      default:
        return '30-40 minutos';
    }
  }

  void _abrirWhatsApp(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Abriendo WhatsApp...'),
        backgroundColor: Color(0xFF25D366),
      ),
    );
  }
}