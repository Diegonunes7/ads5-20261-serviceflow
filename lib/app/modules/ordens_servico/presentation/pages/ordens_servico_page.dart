import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_text_field.dart';
import '../../data/ordem_servico.repository.dart';
import '../../domain/ordem_servico.service.dart';
import '../../domain/ordem_servico.validation.dart';
import '../controllers/ordens_servico.controller.dart';

class OrdensServicoPage extends StatefulWidget {
  const OrdensServicoPage({super.key});

  @override
  State<OrdensServicoPage> createState() => _OrdensServicoPageState();
}

class _OrdensServicoPageState extends State<OrdensServicoPage> {
  late final OrdensServicoController _controller;
  late final TextEditingController _clienteIdController;
  late final TextEditingController _tecnicoIdController;
  late final TextEditingController _observacaoController;
  late final TextEditingController _valorPecasController;

  @override
  void initState() {
    super.initState();
    final repository = OrdemServicoRepository();
    final validation = OrdemServicoValidation(repository);
    final service = OrdemServicoService(
      repository: repository,
      validation: validation,
    );

    _controller = OrdensServicoController(service: service);
    _controller.addListener(_onControllerChanged);
    _controller.loadOrdens();

    _clienteIdController = TextEditingController();
    _tecnicoIdController = TextEditingController();
    _observacaoController = TextEditingController();
    _valorPecasController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _clienteIdController.dispose();
    _tecnicoIdController.dispose();
    _observacaoController.dispose();
    _valorPecasController.dispose();
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

  Future<void> _salvarOrdem() async {
    final saved = await _controller.cadastrarOrdem(
      clienteIdText: _clienteIdController.text,
      tecnicoIdText: _tecnicoIdController.text,
      observacao: _observacaoController.text,
      valorPecasText: _valorPecasController.text,
    );

    if (!saved) return;

    _clienteIdController.clear();
    _tecnicoIdController.clear();
    _observacaoController.clear();
    _valorPecasController.text = '0';
    FocusScope.of(context).unfocus();
  }

  String _syncLabel(int isSync) {
    return isSync == 1 ? 'Sincronizada' : 'Pendente';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ordens de Servico')),
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
                            controller: _clienteIdController,
                            label: 'ID do cliente',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _tecnicoIdController,
                            label: 'ID do tecnico',
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _valorPecasController,
                            label: 'Valor de pecas',
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                            controller: _observacaoController,
                            label: 'Observacao',
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: _salvarOrdem,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _controller.isLoading ? null : _salvarOrdem,
                              child: const Text('Salvar O.S.'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: _controller.ordens.isEmpty
                          ? const Center(
                              child: Text('Nenhuma O.S. cadastrada ainda.'),
                            )
                          : ListView.builder(
                              itemCount: _controller.ordens.length,
                              itemBuilder: (context, index) {
                                final ordem = _controller.ordens[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    child: Text(
                                      ordem.id?.toString() ?? '#',
                                    ),
                                  ),
                                  title: Text(
                                    'Cliente ${ordem.clienteId} - Tecnico ${ordem.tecnicoId}',
                                  ),
                                  subtitle: Text(
                                    'Pecas: R\$ ${ordem.valorPecas.toStringAsFixed(2)}'
                                    '\n${_syncLabel(ordem.isSync)}'
                                    '${ordem.observacao == null ? '' : '\n${ordem.observacao}'}',
                                  ),
                                  isThreeLine: true,
                                  trailing: IconButton(
                                    onPressed: ordem.id == null
                                        ? null
                                        : () => _controller.removerOrdem(
                                              ordem.id!,
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
