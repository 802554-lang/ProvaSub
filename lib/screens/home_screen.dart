import 'package:flutter/material.dart';
import 'package:app_exemplo/services/auth_service.dart';

// 4. Listagem de Dados (Modelo de Estrutura de Item)
class Item {
  final String key;
  final String nome;
  final String descricao;
  final DateTime data;

  Item({
    required this.key,
    required this.nome,
    required this.descricao,
    required this.data,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final AuthService _authService = const AuthService();

  // Função para fazer logout
  void _logout(BuildContext context) async {
    await _authService.signOut();
    // O AuthWrapper no main.dart irá detectar a mudança e redirecionar para a tela de Login.
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  // Função para navegar e aguardar o resultado do cadastro de item
  void _navigateToAddItem(BuildContext context) async {
    await Navigator.of(context).pushNamed('/add_item');
    // TODO: Se necessário, atualizar a lista de itens aqui (será implementado na próxima etapa)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Retornou do Cadastro. Próxima etapa: Listagem!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.getCurrentUser();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página Principal'),
        automaticallyImplyLeading: false, // Remove a seta de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Texto exibindo o e-mail do usuário logado
            Text(
              'Bem-vindo(a)!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Seu e-mail de login é:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              user?.email ?? 'Usuário desconhecido',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Botão para acessar a tela de cadastro de itens
            ElevatedButton.icon(
              onPressed: () => _navigateToAddItem(context),
              icon: const Icon(Icons.add),
              label: const Text('Acessar Cadastro de Itens'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            
            const SizedBox(height: 20),

            // Botão Logout
            OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout),
              label: const Text('Sair (Logout)'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),

            const SizedBox(height: 40),
            Text(
              'Lista de Itens (A ser implementada):',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Expanded(
              child: Center(
                child: Text('A listagem dos itens será implementada na próxima etapa!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}