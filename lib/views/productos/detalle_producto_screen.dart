import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/producto.dart';
import '../../viewmodels/carrito_viewmodel.dart';
import '../../widgets/custom_button.dart';

class DetalleProductoScreen extends StatefulWidget {
  final Producto producto;

  const DetalleProductoScreen({
    super.key,
    required this.producto,
  });

  @override
  State<DetalleProductoScreen> createState() => _DetalleProductoScreenState();
}

class _DetalleProductoScreenState extends State<DetalleProductoScreen> {
  int _cantidad = 1;
  final List<Map<String, dynamic>> _extrasSeleccionados = [];
  final TextEditingController _notasController = TextEditingController();

  // Extras por categoría
  Map<String, List<Map<String, dynamic>>> get _extrasPorCategoria => {
        'bowls': [
          {'nombre': '🥑 Aguacate', 'precio': 3000},
          {'nombre': '🍗 Proteína Extra', 'precio': 5000},
          {'nombre': '🌰 Semillas Mix', 'precio': 2000},
          {'nombre': '🥚 Huevo', 'precio': 2500},
        ],
        'ensaladas': [
          {'nombre': '🧀 Queso Feta', 'precio': 3000},
          {'nombre': '🥓 Tocineta', 'precio': 4000},
          {'nombre': '🥜 Nueces', 'precio': 2500},
          {'nombre': '🥄 Aderezo Premium', 'precio': 2000},
        ],
        'bebidas': [
          {'nombre': '🍯 Miel', 'precio': 1500},
          {'nombre': '🥛 Proteína en Polvo', 'precio': 3000},
          {'nombre': '🧊 Shot de Jengibre', 'precio': 2000},
          {'nombre': '🌿 Espirulina', 'precio': 2500},
        ],
        'postres': [
          {'nombre': '🍓 Fresas Extra', 'precio': 2000},
          {'nombre': '🍫 Chocolate Oscuro', 'precio': 2500},
          {'nombre': '🥥 Coco Rallado', 'precio': 1500},
          {'nombre': '🍯 Miel de Maple', 'precio': 2000},
        ],
      };

  List<Map<String, dynamic>> get _extrasDisponibles =>
      _extrasPorCategoria[widget.producto.categoria] ?? [];

  double get _precioTotal {
    double precioBase = widget.producto.precio * _cantidad;
    double precioExtras = _extrasSeleccionados.fold(
      0,
      (sum, extra) => sum + ((extra['precio'] as int) * (extra['cantidad'] as int) * _cantidad),
    );
    return precioBase + precioExtras;
  }

  @override
  void dispose() {
    _notasController.dispose();
    super.dispose();
  }

  void _changeExtraQuantity(Map<String, dynamic> extra, int nuevaCantidad) {
    setState(() {
      final index = _extrasSeleccionados.indexWhere((e) => e['nombre'] == extra['nombre']);
      if (index != -1) {
        if (nuevaCantidad <= 0) {
          _extrasSeleccionados.removeAt(index);
        } else {
          _extrasSeleccionados[index]['cantidad'] = nuevaCantidad;
        }
      } else if (nuevaCantidad > 0) {
        _extrasSeleccionados.add({
          'nombre': extra['nombre'],
          'precio': extra['precio'],
          'cantidad': nuevaCantidad,
        });
      }
    });
  }

 void _agregarAlCarrito() {
  final carritoVM = context.read<CarritoViewModel>();
  
  carritoVM.agregarProducto(
    widget.producto,
    cantidad: _cantidad,
    extras: _extrasSeleccionados,
    notas: _notasController.text.isEmpty ? null : _notasController.text,
  );

  // brief confirmation
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${widget.producto.nombre} agregado al carrito'),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // AppBar con imagen
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.producto.imagenUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.restaurant, size: 100),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Contenido
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y precio
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.producto.nombre,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${widget.producto.precio.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Descripción
                  Text(
                    widget.producto.descripcion,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ingredientes
                  if (widget.producto.ingredientes.isNotEmpty) ...[
                    const Text(
                      'Ingredientes',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.producto.ingredientes
                          .map((ingrediente) => Chip(
                                label: Text(ingrediente),
                                backgroundColor: Colors.grey[100],
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Extras
                  if (_extrasDisponibles.isNotEmpty) ...[
                    const Text(
                      'Extras',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._extrasDisponibles.map((extra) {
                      final selIndex = _extrasSeleccionados.indexWhere((e) => e['nombre'] == extra['nombre']);
                      final cantidad = selIndex != -1 ? _extrasSeleccionados[selIndex]['cantidad'] as int : 0;
                      return GestureDetector(
                        onTap: () {
                          if (cantidad == 0) {
                            _changeExtraQuantity(extra, 1);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cantidad > 0 ? const Color(0xFF4CAF50).withOpacity(0.1) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: cantidad > 0 ? const Color(0xFF4CAF50) : Colors.grey[300]!,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                cantidad > 0 ? Icons.check_circle : Icons.circle_outlined,
                                color: cantidad > 0 ? const Color(0xFF4CAF50) : Colors.grey,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  extra['nombre'],
                                  style: TextStyle(
                                    fontWeight: cantidad > 0 ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                              Text(
                                '+\$${extra['precio']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: cantidad > 0 ? const Color(0xFF4CAF50) : Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // permanently show add button so user can start selecting the extra
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => _changeExtraQuantity(extra, cantidad + 1),
                                color: const Color(0xFF4CAF50),
                                splashRadius: 20,
                                constraints: const BoxConstraints(),
                                padding: EdgeInsets.zero,
                              ),
                              if (cantidad > 0) ...[
                                const SizedBox(width: 4),
                                Text('$cantidad'),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => _changeExtraQuantity(extra, cantidad - 1),
                                  color: const Color(0xFF4CAF50),
                                  splashRadius: 20,
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],

                  // Notas especiales
                  const Text(
                    'Notas especiales',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notasController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ej: Sin cebolla, sin picante...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom bar
      bottomNavigationBar: Container(
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
        child: SafeArea(
          child: Row(
            children: [
              // Selector de cantidad
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _cantidad > 1
                          ? () => setState(() => _cantidad--)
                          : null,
                    ),
                    // allow tapping the number to input an arbitrary quantity
                    GestureDetector(
                      onTap: () async {
                        final result = await showDialog<String>(
                          context: context,
                          builder: (context) {
                            final controller = TextEditingController(text: '$_cantidad');
                            return AlertDialog(
                              title: const Text('Cantidad'),
                              content: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Ingresa la cantidad',
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, controller.text),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                        if (result != null) {
                          final parsed = int.tryParse(result);
                          if (parsed != null && parsed > 0) {
                            setState(() => _cantidad = parsed);
                          }
                        }
                      },
                      child: Text(
                        '$_cantidad',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => _cantidad++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Botón agregar
              Expanded(
                child: CustomButton(
                  text: 'Agregar \$${_precioTotal.toStringAsFixed(0)}',
                  onPressed: _agregarAlCarrito,
                  icon: Icons.shopping_cart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}