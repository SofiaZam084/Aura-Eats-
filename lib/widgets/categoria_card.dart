import 'package:flutter/material.dart';

class CategoriaCard extends StatelessWidget {
  final String emoji;
  final String nombre;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoriaCard({
    super.key,
    required this.emoji,
    required this.nombre,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0A3323) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF0A3323),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(
              nombre,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF0A3323),
              ),
            ),
          ],
        ),
      ),
    );
  }
}