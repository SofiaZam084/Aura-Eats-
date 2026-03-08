import '../models/producto.dart';

class ProductosService {
  // Datos de ejemplo (simulación de base de datos)
  Future<List<Producto>> obtenerProductos() async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      // BOWLS
      Producto(
        id: '1',
        nombre: 'Bowl Proteico',
        descripcion: 'Quinoa, pollo, aguacate, tomate cherry y aderezo de yogurt',
        precio: 18000,
        categoria: 'bowls',
        imagenUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
        ingredientes: ['Quinoa', 'Pollo', 'Aguacate', 'Tomate', 'Yogurt'],
      ),
      Producto(
        id: '2',
        nombre: 'Bowl Vegano',
        descripcion: 'Arroz integral, garbanzos, espinaca, zanahoria y hummus',
        precio: 16000,
        categoria: 'bowls',
        imagenUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400',
        ingredientes: ['Arroz integral', 'Garbanzos', 'Espinaca', 'Zanahoria'],
      ),
      Producto(
        id: '3',
        nombre: 'Bowl Mediterráneo',
        descripcion: 'Cuscús, atún, aceitunas, pepino y aderezo de limón',
        precio: 19000,
        categoria: 'bowls',
        imagenUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400',
        ingredientes: ['Cuscús', 'Atún', 'Aceitunas', 'Pepino'],
      ),

      // ENSALADAS
      Producto(
        id: '4',
        nombre: 'Ensalada César',
        descripcion: 'Lechuga romana, pollo, queso parmesano, crutones y aderezo césar',
        precio: 15000,
        categoria: 'ensaladas',
        imagenUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400',
        ingredientes: ['Lechuga', 'Pollo', 'Parmesano', 'Crutones'],
      ),
      Producto(
        id: '5',
        nombre: 'Ensalada Griega',
        descripcion: 'Tomate, pepino, cebolla morada, queso feta y aceitunas',
        precio: 14000,
        categoria: 'ensaladas',
        imagenUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400',
        ingredientes: ['Tomate', 'Pepino', 'Feta', 'Aceitunas'],
      ),
      Producto(
        id: '6',
        nombre: 'Ensalada de Quinoa',
        descripcion: 'Quinoa, aguacate, tomate, cilantro y limón',
        precio: 16000,
        categoria: 'ensaladas',
        imagenUrl: 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?w=400',
        ingredientes: ['Quinoa', 'Aguacate', 'Tomate', 'Cilantro'],
      ),

      // BEBIDAS
      Producto(
        id: '7',
        nombre: 'Smoothie Verde',
        descripcion: 'Espinaca, manzana verde, plátano y jengibre',
        precio: 12000,
        categoria: 'bebidas',
        imagenUrl: 'https://images.unsplash.com/photo-1610970881699-44a5587cabec?w=400',
        ingredientes: ['Espinaca', 'Manzana', 'Plátano', 'Jengibre'],
      ),
      Producto(
        id: '8',
        nombre: 'Jugo Detox',
        descripcion: 'Naranja, zanahoria, jengibre y cúrcuma',
        precio: 11000,
        categoria: 'bebidas',
        imagenUrl: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
        ingredientes: ['Naranja', 'Zanahoria', 'Jengibre', 'Cúrcuma'],
      ),
      Producto(
        id: '9',
        nombre: 'Smoothie de Frutos Rojos',
        descripcion: 'Fresas, arándanos, frambuesas y yogurt griego',
        precio: 13000,
        categoria: 'bebidas',
        imagenUrl: 'https://images.unsplash.com/photo-1553530979-7ee52a2670c4?w=400',
        ingredientes: ['Fresas', 'Arándanos', 'Frambuesas', 'Yogurt'],
      ),

      // POSTRES
      Producto(
        id: '10',
        nombre: 'Chia Pudding',
        descripcion: 'Semillas de chía, leche de almendras, frutos rojos y miel',
        precio: 10000,
        categoria: 'postres',
        imagenUrl: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400',
        ingredientes: ['Chía', 'Leche de almendras', 'Frutos rojos', 'Miel'],
      ),
      Producto(
        id: '11',
        nombre: 'Brownie Saludable',
        descripcion: 'Chocolate oscuro, plátano, avena y nueces',
        precio: 9000,
        categoria: 'postres',
        imagenUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400',
        ingredientes: ['Chocolate', 'Plátano', 'Avena', 'Nueces'],
      ),
      Producto(
        id: '12',
        nombre: 'Yogurt Parfait',
        descripcion: 'Yogurt griego, granola, miel y frutas frescas',
        precio: 11000,
        categoria: 'postres',
        imagenUrl: 'https://images.unsplash.com/photo-1488477304112-4944851de03d?w=400',
        ingredientes: ['Yogurt', 'Granola', 'Miel', 'Frutas'],
      ),
    ];
  }
}