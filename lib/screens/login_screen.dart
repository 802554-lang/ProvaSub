import 'package:flutter/material.dart';
import 'package:app_exemplo/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    String? errorMessage = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (errorMessage == null) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      } else {.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text('Entrar'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/register');
                },
                child: const Text('Não tenho conta. Cadastrar-me.'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}