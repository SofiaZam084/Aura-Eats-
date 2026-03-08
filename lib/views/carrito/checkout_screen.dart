import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/carrito_viewmodel.dart';
import '../../viewmodels/pedidos_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../pedidos/detalle_pedido_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _notasController = TextEditingController();
  
  String _metodoPago = 'Efectivo';
  bool _isProcessing = false;

  @override
  void dispose() {
    _direccionController.dispose();
    _telefonoController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _confirmarPedido() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    final carritoVM = context.read<CarritoViewModel>();
    final pedidosVM = context.read<PedidosViewModel>();
    final authVM = context.read<AuthViewModel>();

    final usuarioId = authVM.usuarioActual?.id;
    if (usuarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para realizar el pedido')),
      );
      setState(() => _isProcessing = false);
      return;
    }

    final pedido = await pedidosVM.crearPedido(
      usuarioId: usuarioId,
      items: carritoVM.items,
      total: carritoVM.total + 3000,
      metodoPago: _metodoPago,
      direccion: _direccionController.text,
      telefono: _telefonoController.text,
    );

    setState(() => _isProcessing = false);

    if (!mounted) return;

    if (pedido != null) {
      carritoVM.limpiarCarrito();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DetallePedidoScreen(pedido: pedido),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text('Error al crear el pedido'),
    backgroundColor: Color(0xFFD3968C),
    duration: Duration(seconds: 3),
    behavior: SnackBarBehavior.floating, 
  ),
);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Confirmar Pedido'),
        elevation: 0,
      ),
      body: Consumer<CarritoViewModel>(
        builder: (context, carritoVM, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSeccion(
                    titulo: 'Resumen del pedido',
                    icono: Icons.shopping_bag_outlined,
                    child: Column(
                      children: [
                        ...carritoVM.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item.cantidad}x ${item.producto.nombre}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              Text(
                                '\$${item.subtotal.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )),
                        const Divider(),
                        _buildFilaTotal('Subtotal', carritoVM.total),
                        _buildFilaTotal('Domicilio', 3000),
                        const Divider(),
                        _buildFilaTotal(
                          'Total',
                          carritoVM.total + 3000,
                          esTotal: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildSeccion(
                    titulo: 'Información de entrega',
                    icono: Icons.location_on_outlined,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _direccionController,
                          decoration: const InputDecoration(
                            labelText: 'Dirección completa',
                            hintText: 'Calle, número, apartamento...',
                            prefixIcon: Icon(Icons.home_outlined),
                          ),
                          maxLines: 2,
                          validator: (v) => v!.isEmpty 
                              ? 'Ingresa tu dirección' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _telefonoController,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono de contacto',
                            hintText: '3001234567',
                            prefixIcon: Icon(Icons.phone_outlined),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (v) => v!.isEmpty 
                              ? 'Ingresa tu teléfono' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _notasController,
                          decoration: const InputDecoration(
                            labelText: 'Notas adicionales (opcional)',
                            hintText: 'Ej: Tocar el timbre, casa azul...',
                            prefixIcon: Icon(Icons.note_outlined),
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildSeccion(
                    titulo: 'Método de pago',
                    icono: Icons.payment_outlined,
                    child: Column(
                      children: [
                        RadioListTile<String>(
                          value: 'Efectivo',
                          groupValue: _metodoPago,
                          onChanged: (String? v) {
                            if (v != null) {
                              setState(() => _metodoPago = v);
                            }
                          },
                          title: const Text('Efectivo'),
                          subtitle: const Text('Paga al recibir'),
                          secondary: const Icon(Icons.money),
                          activeColor: const Color(0xFF4CAF50),
                        ),
                        RadioListTile<String>(
                          value: 'Tarjeta',
                          groupValue: _metodoPago,
                          onChanged: (String? v) {
                            if (v != null) {
                              setState(() => _metodoPago = v);
                            }
                          },
                          title: const Text('Tarjeta (Datafono)'),
                          subtitle: const Text('Débito o crédito'),
                          secondary: const Icon(Icons.credit_card),
                          activeColor: const Color(0xFF4CAF50),
                        ),
                        RadioListTile<String>(
                          value: 'Nequi',
                          groupValue: _metodoPago,
                          onChanged: (String? v) {
                            if (v != null) {
                              setState(() => _metodoPago = v);
                            }
                          },
                          title: const Text('Nequi'),
                          subtitle: const Text('Transferencia'),
                          secondary: const Icon(Icons.smartphone),
                          activeColor: const Color(0xFF4CAF50),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  CustomButton(
                    text: 'Confirmar pedido - \$${(carritoVM.total + 3000).toStringAsFixed(0)}',
                    onPressed: _confirmarPedido,
                    isLoading: _isProcessing,
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeccion({
    required String titulo,
    required IconData icono,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, color: const Color(0xFF4CAF50)),
              const SizedBox(width: 8),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildFilaTotal(String label, double monto, {bool esTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: esTotal ? 16 : 14,
              fontWeight: esTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '\$${monto.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: esTotal ? 18 : 14,
              fontWeight: FontWeight.bold,
              color: esTotal ? const Color(0xFF4CAF50) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}