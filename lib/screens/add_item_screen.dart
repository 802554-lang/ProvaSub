import 'package:flutter/material.dart';
import 'package:app_exemplo/services/database_service.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = false;

  void _saveItem() async {
    final nome = _nameController.text.trim();
    final descricao = _descriptionController.text.trim();

    if (nome.isEmpty || descricao.isEmpty) {
      _showSnackBar('Por favor, preencha todos os campos.', isError: true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _dbService.addItem(nome, descricao);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      final isSuccess = result?.startsWith('Sucesso') ?? false;
      _showSnackBar(result ?? 'Erro desconhecido.', isError: !isSuccess);

      if (isSuccess) {
        // Limpa os campos após o sucesso e retorna para a tela anterior
        _nameController.clear();
        _descriptionController.clear();
        Navigator.of(context).pop(true); // Retorna 'true' para indicar sucesso e talvez atualizar a tela anterior
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Item'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Campo: nome do item
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nome do Item',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 20),
            
            // Campo: descrição
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.description),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 40),

            // Botão: Salvar
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _saveItem,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Item'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}