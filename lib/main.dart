import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_exemplo/services/auth_service.dart';
import 'package:app_exemplo/screens/login_screen.dart';
import 'package:app_exemplo/screens/home_screen.dart';
import 'package:app_exemplo/screens/register_screen.dart';
import 'package:app_exemplo/screens/add_item_screen.dart'; 

// Importe seu arquivo firebase_options.dart gerado pelo flutterfire configure
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa o Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define as rotas nomeadas
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add_item': (context) => const AddItemScreen(), // Rota do cadastro de itens
      },
      initialRoute: '/',
    );
  }
}

// Wrapper que decide qual tela mostrar com base no estado de autenticação
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta as mudanças no estado de autenticação (logado ou deslogado)
    return StreamBuilder<User?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Exibe um indicador de carregamento enquanto espera o estado de Auth
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Se o usuário está logado (snapshot.hasData e snapshot.data != null), mostra a HomeScreen
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen(); 
        }

        // Se o usuário não está logado, mostra a LoginScreen
        return const LoginScreen();
      },
    );
  }
}