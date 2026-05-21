import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../data/usuario.repository.dart';
import '../../domain/usuario.service.dart';
import '../../domain/usuario.validation.dart';
import '../controllers/usuarios.controller.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  late final UsuariosController _controller;
  late final TextEditingController _nomeController;
  late final TextEditingController _emailController;
  late final TextEditingController _grupoController;
  late final TextEditingController _perfilController;

  @override
  void initState() {
    super.initState();
    final repository = UsuarioRepository();
    final validation = UsuarioValidation(repository);
    final service = UsuarioService(
      repository: repository,
      validation: validation,
    );

    _controller = UsuariosController(service: service);
    _controller.addListener(_onControllerChanged);
    _controller.loadUsuarios();

    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _grupoController = TextEditingController(text: 'local');
    _perfilController = TextEditingController(text: 'tecnico');
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _nomeController.dispose();
    _emailController.dispose();
    _grupoController.dispose();
    _perfilController.dispose();
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

  Future<void> _salvarUsuario() async {
    final saved = await _controller.cadastrarUsuario(
      nomeCompleto: _nomeController.text,
      email: _emailController.text,
      grupoId: _grupoController.text,
      perfil: _perfilController.text,
    );

    if (!saved) return;

    _nomeController.clear();
    _emailController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
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
                            label: 'Nome completo',
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _emailController,
                            label: 'E-mail',
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _grupoController,
                            label: 'Grupo',
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _perfilController,
                            label: 'Perfil',
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: _salvarUsuario,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _controller.isLoading ? null : _salvarUsuario,
                              child: const Text('Salvar Usuario'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: _controller.usuarios.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum usuario cadastrado ainda.',
                              ),
                            )
                          : ListView.builder(
                              itemCount: _controller.usuarios.length,
                              itemBuilder: (context, index) {
                                final usuario = _controller.usuarios[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      usuario.nomeCompleto.isEmpty
                                          ? '?'
                                          : usuario.nomeCompleto[0]
                                              .toUpperCase(),
                                    ),
                                  ),
                                  title: Text(usuario.nomeCompleto),
                                  subtitle: Text(
                                    '${usuario.email}\n${usuario.perfil}',
                                  ),
                                  isThreeLine: true,
                                  trailing: IconButton(
                                    onPressed: usuario.id == null
                                        ? null
                                        : () => _controller.removerUsuario(
                                              usuario.id!,
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
