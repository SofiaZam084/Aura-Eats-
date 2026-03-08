import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/carrito_viewmodel.dart';
import '../../viewmodels/pedidos_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_button.dart';
import '../pedidos/pedido_confirmado_screen.dart';

class ConfirmarPedidoScreen extends StatefulWidget {
  const ConfirmarPedidoScreen({super.key});

  @override
  State<ConfirmarPedidoScreen> createState() => _ConfirmarPedidoScreenState();
}

class _ConfirmarPedidoScreenState extends State<ConfirmarPedidoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  String _metodoPago = 'contraentrega';

  @override
  void dispose() {
    _direccionController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _confirmarPedido() async {
    if (_formKey.currentState!.validate()) {
      final carritoVM = context.read<CarritoViewModel>();
      final pedidosVM = context.read<PedidosViewModel>();
      final authVM = context.read<AuthViewModel>();

      final pedido = await pedidosVM.crearPedido(
        usuarioId: authVM.usuarioActual?.id ?? 'demo',
        items: carritoVM.items,
        total: carritoVM.total + 3000,
        metodoPago: _metodoPago,
        direccion: _direccionController.text,
        telefono: _telefonoController.text,
      );

      if (!mounted) return;

      if (pedido != null) {
        carritoVM.limpiarCarrito();
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PedidoConfirmadoScreen(pedidoId: pedido.id),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final carritoVM = context.watch<CarritoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Pedido'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Resumen del pedido
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resumen',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${carritoVM.cantidadTotal} productos'),
                        Text('\$${carritoVM.total.toStringAsFixed(0)}'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Domicilio'),
                        Text('\$${3000}'),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${(carritoVM.total + 3000).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Dirección
            const Text(
              'Dirección de entrega',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _direccionController,
              decoration: InputDecoration(
                hintText: 'Calle 123 #45-67',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) => v!.isEmpty ? 'Ingresa tu dirección' : null,
            ),

            const SizedBox(height: 16),

            // Teléfono
            const Text(
              'Teléfono de contacto',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _telefonoController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '300 123 4567',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (v) => v!.isEmpty ? 'Ingresa tu teléfono' : null,
            ),

            const SizedBox(height: 24),

            // Método de pago
            const Text(
              'Método de pago',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            RadioListTile(
              value: 'contraentrega',
              groupValue: _metodoPago,
              onChanged: (v) => setState(() => _metodoPago = v!),
              title: const Text('Pago contra entrega'),
              subtitle: const Text('Efectivo o tarjeta al recibir'),
              activeColor: const Color(0xFF4CAF50),
            ),
            RadioListTile(
              value: 'digital',
              groupValue: _metodoPago,
              onChanged: (v) => setState(() => _metodoPago = v!),
              title: const Text('Pago digital'),
              subtitle: const Text('Próximamente'),
              activeColor: const Color(0xFF4CAF50),
              enabled: false,
            ),

            const SizedBox(height: 24),

            Consumer<PedidosViewModel>(
              builder: (context, pedidosVM, _) => CustomButton(
                text: 'Confirmar Pedido',
                onPressed: _confirmarPedido,
                isLoading: pedidosVM.isLoading,
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}