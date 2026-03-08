import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/productos_viewmodel.dart';
import '../../viewmodels/carrito_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/categoria_card.dart';
import '../../widgets/producto_card.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../productos/detalle_producto_screen.dart';
import '../carrito/carrito_screen.dart';
import '../pedidos/mis_pedidos_screen.dart';
import '../soporte/soporte_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4D5),
      body: _buildBody(),
      bottomNavigationBar: Consumer<CarritoViewModel>(
        builder: (context, carrito, _) => BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          carritoCount: carrito.cantidadTotal,
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildInicioContent(); // ← Hero + Features
      case 1:
        return _buildMenuContent(); // ← Catálogo de productos
      case 2:
        return const CarritoScreen();
      case 3:
        return _buildPerfilContent();
      default:
        return _buildInicioContent();
    }
  }

  // INICIO - Hero + Features
  Widget _buildInicioContent() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A3323), Color(0xFF105666)],
                ),
              ),
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Text('🥗', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 12),
                  const Text(
                    'Nutrición natural para tu cuerpo y alma',
                    style: TextStyle(
                      color: Color(0xFFF7F4D5),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () => setState(() => _currentIndex = 1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF839958),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Explorar Menú',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildFeatureCard(
                    emoji: '🌱',
                    title: '100% Orgánico',
                    subtitle: 'Ingredientes frescos y naturales',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    emoji: '💪',
                    title: 'Alto en Nutrientes',
                    subtitle: 'Comidas balanceadas y saludables',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureCard(
                    emoji: '🚴',
                    title: 'Entrega Rápida',
                    subtitle: 'Fresco en 30 minutos',
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String emoji,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A3323).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFF7F4D5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 32)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A3323),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MENÚ - Catálogo de productos
  Widget _buildMenuContent() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menú',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A3323),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Encuentra tu plato favorito',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Consumer<ProductosViewModel>(
              builder: (context, productosVM, _) {
                return SizedBox(
                  height: 50,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: productosVM.categorias.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final categoria = productosVM.categorias[index];
                      return CategoriaCard(
                        emoji: categoria['emoji']!,
                        nombre: categoria['nombre']!,
                        isSelected: productosVM.categoriaSeleccionada ==
                            categoria['id'],
                        onTap: () => productosVM
                            .cambiarCategoria(categoria['id']!),
                      );
                    },
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          Consumer<ProductosViewModel>(
            builder: (context, productosVM, _) {
              if (productosVM.isLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0A3323),
                    ),
                  ),
                );
              }

              if (productosVM.productos.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No hay productos disponibles',
                      style: TextStyle(color: Color(0xFF0A3323)),
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 240, // fixed height for consistency
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final producto = productosVM.productos[index];
                      return ProductoCard(
                        producto: producto,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalleProductoScreen(
                                producto: producto,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    childCount: productosVM.productos.length,
                  ),
                ),
              );
            },
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildPerfilContent() {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        return Container(
          color: const Color(0xFFF7F4D5),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),
              
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A3323), Color(0xFF105666)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: Color(0xFF0A3323),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      authVM.usuarioActual?.nombre ?? 'Usuario',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      authVM.usuarioActual?.email ?? '',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              _buildOpcion(
                context,
                icono: Icons.receipt_long,
                titulo: 'Mis Pedidos',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MisPedidosScreen(),
                    ),
                  );
                },
              ),
              
              _buildOpcion(
                context,
                icono: Icons.support_agent,
                titulo: 'Soporte',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SoporteScreen(),
                    ),
                  );
                },
              ),
              
              _buildOpcion(
                context,
                icono: Icons.logout,
                titulo: 'Cerrar Sesión',
                color: const Color(0xFFD3968C),
                onTap: () async {
                  await authVM.cerrarSesion();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOpcion(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: ListTile(
        leading: Icon(icono, color: color ?? const Color(0xFF0A3323)),
        title: Text(
          titulo,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color ?? const Color(0xFF0A3323),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}