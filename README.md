
Descripción
AuraEats es una aplicación móvil desarrollada con Flutter que conecta a los usuarios con opciones de comida saludable. Permite explorar productos, agregarlos al carrito, realizar pedidos y hacer seguimiento en tiempo real, todo respaldado por Firebase.

Módulo	Funcionalidad
🔐 Autenticación	Registro, inicio de sesión y recuperación de contraseña con Firebase Auth
🏠 Home	Pantalla principal con categorías y productos destacados
🔍 Búsqueda	Búsqueda de productos por nombre o categoría
🛍️ Productos	Catálogo de productos saludables con detalle y precio
🛒 Carrito	Agregar/eliminar productos, resumen de compra
📦 Pedidos	Confirmación, historial y seguimiento de pedidos
💬 Soporte	Canal de contacto y ayuda dentro de la app

🛠 Tecnologías

Framework: Flutter 3.x + Dart 3.x
Backend / BaaS: Firebase

firebase_auth — Autenticación de usuarios
cloud_firestore — Base de datos en tiempo real
firebase_core — Inicialización


Gestión de estado: Provider
UI: Google Fonts + Material Design 3
Utilidades: intl, uuid, url_launcher, shared_preferences


🏗 Arquitectura
El proyecto sigue el patrón MVVM (Model - View - ViewModel) para una separación clara de responsabilidades:


Models: Estructuras de datos (Producto, Pedido, CarritoItem, Usuario)
Services: Comunicación directa con Firebase (FirebaseService, ProductosService, PedidosService)

ViewModels: Lógica y estado de cada módulo (AuthViewModel, CarritoViewModel, etc.)

Views: Pantallas Flutter que consumen los ViewModels vía Provider
Widgets: Componentes reutilizables (ProductoCard, PedidoCard, CustomButton, etc.)

Requisitos Previos

Antes de clonar y ejecutar el proyecto, asegúrate de tener instalado:
HerramientaVersión mínimaDescargaFlutter SDK3.0.0flutter.devDart SDK3.0.0Incluido con FlutterAndroid StudioHedgehog+developer.android.comJDK17adoptium.netGitCualquieragit-scm.comXcode (solo iOS)15+Mac App Store
Verificar la instalación de Flutter:
bashflutter doctor

🚀 Instalación y Configuración
1. Clonar el repositorio
bashgit clone https://github.com/tu-usuario/auraeats.git
cd auraeats
2. Instalar dependencias
bashflutter pub get
3. Configurar Firebase (ver sección siguiente)
4. Ejecutar la app en modo desarrollo
bash# En un emulador o dispositivo conectado
flutter run

# Especificar dispositivo
flutter run -d android
flutter run -d ios