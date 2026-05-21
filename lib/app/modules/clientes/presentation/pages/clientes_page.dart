import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../data/cliente.repository.dart';
import '../../domain/cliente.service.dart';
import '../../domain/cliente.validation.dart';
import '../controllers/clientes.controller.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  late final ClientesController _controller;
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    final repository = ClienteRepository();
    final validation = ClienteValidation(repository);
    final service = ClienteService(
      repository: repository,
      validation: validation,
    );

    _controller = ClientesController(service: service);
    _controller.addListener(_onControllerChanged);
    _controller.loadClientes();

    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _telefoneController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;

    final success = _controller.successMessage;
    if (success != null) {
      _showMessage(success.text, success.duration, Colors.green.shade700);
      return;
    }

    final warning = _controller.warningMessage;
    if (warning != null) {
      _showMessage(warning.text, warning.duration, Colors.orange.shade700);
      return;
    }

    final error = _controller.errorMessage;
    if (error != null) {
      _showMessage(error.text, error.duration, Colors.red.shade700);
    }
  }

  void _showMessage(String text, Duration duration, Color color) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(text),
          backgroundColor: color,
          duration: duration == Duration.zero
              ? const Duration(seconds: 4)
              : duration,
        ),
      );

    _controller.clearMessages();
  }

  Future<void> _salvarCliente() async {
    final saved = await _controller.cadastrarCliente(
      nome: _nomeController.text,
      email: _emailController.text,
      telefone: _telefoneController.text,
    );

    if (!saved) return;

    _nomeController.clear();
    _emailController.clear();
    _telefoneController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: _nomeController,
                            label: 'Nome',
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _emailController,
                            label: 'E-mail',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _telefoneController,
                            label: 'Telefone',
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: _salvarCliente,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _controller.isLoading ? null : _salvarCliente,
                              child: const Text('Salvar Cliente'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: _controller.clientes.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum cliente cadastrado ainda.',
                              ),
                            )
                          : ListView.builder(
                              itemCount: _controller.clientes.length,
                              itemBuilder: (context, index) {
                                final cliente = _controller.clientes[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      cliente.nome.isEmpty
                                          ? '?'
                                          : cliente.nome[0].toUpperCase(),
                                    ),
                                  ),
                                  title: Text(cliente.nome),
                                  subtitle: Text(
                                    '${cliente.email}\n${cliente.telefone}',
                                  ),
                                  isThreeLine: true,
                                  trailing: IconButton(
                                    onPressed: cliente.id == null
                                        ? null
                                        : () => _controller.removerCliente(
                                              cliente.id!,
                                            ),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
                if (_controller.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.08),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
