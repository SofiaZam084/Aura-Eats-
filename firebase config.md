Este proyecto incluye una configuración Firebase pública de demostración que permite a cualquiera clonar y ejecutar la aplicación sin necesidad de crear su propio proyecto Firebase.
⚠️ IMPORTANTE
Las credenciales de Firebase en este repositorio son públicas y solo para demostración.
NO son privadas ni secretas - cualquiera puede verlas en el código fuente.
Esto es seguro porque:

✅ Las reglas de Firestore protegen los datos
✅ Solo se puede acceder a datos del propio usuario
✅ No hay información sensible en la base de datos
✅ Es solo para propósitos educativos

📋 CREDENCIALES PÚBLICAS
Las siguientes credenciales están configuradas en web/index.html y lib/main.dart:

 apiKey: "AIzaSyCA5rAlgaKfMcnG1sYkCy3otzOhRUkWQRA",
  authDomain: "auraeats-app.firebaseapp.com",
  projectId: "auraeats-app",
  storageBucket: "auraeats-app.firebasestorage.app",
  messagingSenderId: "962476849560",
  appId: "1:962476849560:web:7df05ebf4cafe1484893ed"

🚀 CÓMO USAR
Opción 1: Usar Firebase Público (Recomendado para pruebas)

Clonar el repositorio:

bash   git clone https://github.com/SofiaZam084/Aura-Eats-.git
   cd auraeats

Instalar dependencias:

bash   flutter pub get

Ejecutar directamente:

bash   flutter run -d chrome
¡Eso es todo! La app usará el Firebase público configurado.