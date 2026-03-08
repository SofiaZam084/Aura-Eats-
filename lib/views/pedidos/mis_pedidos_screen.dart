import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/pedidos_viewmodel.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/pedido_card.dart';
import 'detalle_pedido_screen.dart';

class MisPedidosScreen extends StatefulWidget {
  const MisPedidosScreen({super.key});

  @override
  State<MisPedidosScreen> createState() => _MisPedidosScreenState();
}

class _MisPedidosScreenState extends State<MisPedidosScreen> {
  @override
  void initState() {
    super.initState();
    // attempt to fetch orders now, but the auth state may not yet be ready
    _cargarPedidos();
  }

  Future<void> _cargarPedidos() async {
    final authVM = context.read<AuthViewModel>();
    final pedidosVM = context.read<PedidosViewModel>();
    final userId = authVM.usuarioActual?.id;

    if (userId == null) {
      // if the user is not authenticated yet we can't load orders; wait for
      // auth state and reload automatically in didChangeDependencies.
      debugPrint('MisPedidosScreen: usuarioActual is null, skipping carga');
      return;
    }

    debugPrint('MisPedidosScreen: cargando pedidos para usuario $userId');
    await pedidosVM.cargarPedidos(userId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // every time dependencies change (including when AuthViewModel updates)
    // try loading orders again so we don't rely on initState timing.
    _cargarPedidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mis Pedidos'),
        elevation: 0,
      ),
      body: Consumer<PedidosViewModel>(
        builder: (context, pedidosVM, _) {
          if (pedidosVM.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (pedidosVM.pedidos.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No tienes pedidos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tus pedidos aparecerán aquí',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _cargarPedidos,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pedidosVM.pedidos.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final pedido = pedidosVM.pedidos[index];
                return PedidoCard(
                  pedido: pedido,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetallePedidoScreen(
                          pedido: pedido,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}