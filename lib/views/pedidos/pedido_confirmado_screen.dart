import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/pedidos_viewmodel.dart';
import '../../widgets/custom_button.dart';
import 'seguimiento_screen.dart';

class PedidoConfirmadoScreen extends StatefulWidget {
  final String pedidoId;

  const PedidoConfirmadoScreen({
    super.key,
    required this.pedidoId,
  });

  @override
  State<PedidoConfirmadoScreen> createState() => _PedidoConfirmadoScreenState();
}

class _PedidoConfirmadoScreenState extends State<PedidoConfirmadoScreen> {
  @override
  void initState() {
    super.initState();
    // show a notification/snackbar after a short delay to simulate a push
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tu pedido ha sido enviado 🚀'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pedidosVM = context.watch<PedidosViewModel>();
    final pedido = pedidosVM.obtenerPedidoPorId(widget.pedidoId);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícono de éxito
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 80,
                  color: Color(0xFF4CAF50),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                '¡Pedido Confirmado!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                'Tu pedido ha sido recibido y está siendo preparado',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Info del pedido
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Número de pedido',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '#${widget.pedidoId.substring(0, 8).toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '\$${pedido?.total.toStringAsFixed(0) ?? '0'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Método de pago',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          (pedido?.metodoPago ?? '') == 'contraentrega'
                              ? 'Contra entrega'
                              : 'Digital',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Tiempo estimado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tiempo estimado de entrega',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '30 - 45 minutos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Botones
              CustomButton(
                text: 'Seguir mi pedido',
                onPressed: () {
                  if (pedido != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeguimientoScreen(
                          pedido: pedido,
                        ),
                      ),
                    );
                  } else {
                    // si no se encuentra el pedido, volvemos al inicio
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                },
                icon: Icons.location_on,
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text(
                  'Volver al inicio',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}