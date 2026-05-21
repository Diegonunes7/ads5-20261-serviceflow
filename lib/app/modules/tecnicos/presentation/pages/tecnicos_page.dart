import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../data/tecnico.repository.dart';
import '../../domain/tecnico.service.dart';
import '../../domain/tecnico.validation.dart';
import '../controllers/tecnicos.controller.dart';

class TecnicosPage extends StatefulWidget {
  const TecnicosPage({super.key});

  @override
  State<TecnicosPage> createState() => _TecnicosPageState();
}

class _TecnicosPageState extends State<TecnicosPage> {
  late final TecnicosController _controller;
  late final TextEditingController _nomeController;
  late final TextEditingController _especialidadeController;

  @override
  void initState() {
    super.initState();
    final repository = TecnicoRepository();
    final validation = TecnicoValidation(repository);
    final service = TecnicoService(
      repository: repository,
      validation: validation,
    );

    _controller = TecnicosController(service: service);
    _controller.addListener(_onControllerChanged);
    _controller.loadTecnicos();

    _nomeController = TextEditingController();
    _especialidadeController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _nomeController.dispose();
    _especialidadeController.dispose();
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

  Future<void> _salvarTecnico() async {
    final saved = await _controller.cadastrarTecnico(
      nome: _nomeController.text,
      especialidade: _especialidadeController.text,
    );

    if (!saved) return;

    _nomeController.clear();
    _especialidadeController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tecnicos')),
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
                            controller: _especialidadeController,
                            label: 'Especialidade',
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: _salvarTecnico,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _controller.isLoading ? null : _salvarTecnico,
                              child: const Text('Salvar Tecnico'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: _controller.tecnicos.isEmpty
                          ? const Center(
                              child: Text(
                                'Nenhum tecnico cadastrado ainda.',
                              ),
                            )
                          : ListView.builder(
                              itemCount: _controller.tecnicos.length,
                              itemBuilder: (context, index) {
                                final tecnico = _controller.tecnicos[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      tecnico.nome.isEmpty
                                          ? '?'
                                          : tecnico.nome[0].toUpperCase(),
                                    ),
                                  ),
                                  title: Text(tecnico.nome),
                                  subtitle: Text(
                                    tecnico.especialidade?.isNotEmpty == true
                                        ? tecnico.especialidade!
                                        : 'Sem especialidade',
                                  ),
                                  trailing: IconButton(
                                    onPressed: tecnico.id == null
                                        ? null
                                        : () => _controller.removerTecnico(
                                              tecnico.id!,
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
