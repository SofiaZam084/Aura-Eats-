import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/productos_viewmodel.dart';
import 'viewmodels/carrito_viewmodel.dart';
import 'viewmodels/pedidos_viewmodel.dart';
import 'views/auth/login_screen.dart';
import 'views/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCA5rAlgaKfMcnG1sYkCy3otzOhRUkWQRA",
  authDomain: "auraeats-app.firebaseapp.com",
  projectId: "auraeats-app",
  storageBucket: "auraeats-app.firebasestorage.app",
  messagingSenderId: "962476849560",
  appId: "1:962476849560:web:7df05ebf4cafe1484893ed"
    ),
  );
   
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProductosViewModel()),
        ChangeNotifierProvider(create: (_) => CarritoViewModel()),
        ChangeNotifierProvider(create: (_) => PedidosViewModel()),
      ],
      child: MaterialApp(
        title: 'AuraEats',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF0A3323),
          scaffoldBackgroundColor: const Color(0xFFF7F4D5),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0A3323),
            primary: const Color(0xFF0A3323),
            secondary: const Color(0xFF839958),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0A3323),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: Consumer<AuthViewModel>(
          builder: (context, authVM, _) {
            return authVM.isAuthenticated 
                ? const HomeScreen() 
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}