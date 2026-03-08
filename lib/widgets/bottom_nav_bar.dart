import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int carritoCount;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.carritoCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0A3323).withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
  icon: Icons.home_outlined,
  selectedIcon: Icons.home,
  label: 'Inicio', // ← CAMBIAR
  index: 0,
),
_buildNavItem(
  icon: Icons.restaurant_menu, // ← CAMBIAR ÍCONO
  selectedIcon: Icons.restaurant,
  label: 'Menú', // ← CAMBIAR
  index: 1,
),
              _buildNavItem(
                icon: Icons.search_outlined,
                selectedIcon: Icons.search,
                label: 'Buscar',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.shopping_cart_outlined,
                selectedIcon: Icons.shopping_cart,
                label: 'Carrito',
                index: 2,
                badge: carritoCount > 0 ? carritoCount : null,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Perfil',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    int? badge,
  }) {
    final isSelected = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0A3323).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? const Color(0xFF0A3323) : Colors.grey,
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected ? const Color(0xFF0A3323) : Colors.grey,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                right: -8,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD3968C),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  child: Center(
                    child: Text(
                      badge > 9 ? '9+' : badge.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}