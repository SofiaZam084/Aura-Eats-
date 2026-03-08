import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/carrito_viewmodel.dart';
import '../../widgets/custom_button.dart';
import 'checkout_screen.dart';

class CarritoScreen extends StatelessWidget {
  const CarritoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<CarritoViewModel>(
        builder: (context, carritoVM, _) {
          if (carritoVM.estaVacio) {
            return _buildCarritoVacio();
          }

          return Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mi Carrito',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Limpiar carrito'),
                            content: const Text(
                              '¿Estás seguro de eliminar todos los productos?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () {
                                  carritoVM.limpiarCarrito();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Limpiar',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text(
                        'Limpiar',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

              // Items
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: carritoVM.items.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final item = carritoVM.items[index];
                    return _buildCarritoItem(context, item, carritoVM);
                  },
                ),
              ),

              // Resumen
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '\$${carritoVM.total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Domicilio',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '\$${3000}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${(carritoVM.total + 3000).toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                 CustomButton(
  text: 'Proceder al pago',
  onPressed: () {
    
  Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CheckoutScreen(),  // ← SIN const
  ),
);
  },
  icon: Icons.payment,
),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCarritoItem(
    BuildContext context,
    item,
    CarritoViewModel carritoVM,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.producto.imagenUrl,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 80,
                height: 80,
                color: Colors.grey[200],
                child: const Icon(Icons.restaurant),
              );
            },
          ),
        ),
        const SizedBox(width: 12),

        // Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.producto.nombre,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              if (item.extras.isNotEmpty) ...[
                Text(
                  'Extras: ${item.extras.map((e) => e['nombre']).join(', ')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Text(
                '\$${item.subtotal.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ),

        // Controles de cantidad
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => carritoVM.incrementarCantidad(item.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
              Text(
                '${item.cantidad}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove, size: 18),
                onPressed: () => carritoVM.decrementarCantidad(item.id),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCarritoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Tu carrito está vacío',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega productos para continuar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
