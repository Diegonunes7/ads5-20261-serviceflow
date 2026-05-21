import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../../../shared/widgets/custom_dropdown_field.dart';
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
  late final TextEditingController _observacaoController;
  late final TextEditingController _valorPecasController;
  final ImagePicker _imagePicker = ImagePicker();
  int? _selectedClienteId;
  int? _selectedTecnicoId;
  String? _fotoAntesPath;
  String? _fotoDepoisPath;
  bool _isCapturandoFoto = false;

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
    _controller.loadDadosTela();

    _observacaoController = TextEditingController();
    _valorPecasController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
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
      clienteId: _selectedClienteId,
      tecnicoId: _selectedTecnicoId,
      observacao: _observacaoController.text,
      valorPecasText: _valorPecasController.text,
      fotoAntesPath: _fotoAntesPath,
      fotoDepoisPath: _fotoDepoisPath,
    );

    if (!saved) return;

    _observacaoController.clear();
    _valorPecasController.text = '0';
    setState(() {
      _selectedClienteId = null;
      _selectedTecnicoId = null;
      _fotoAntesPath = null;
      _fotoDepoisPath = null;
    });
    FocusScope.of(context).unfocus();
  }

  Future<void> _capturarFoto({required bool isAntes}) async {
    if (_isCapturandoFoto) return;

    setState(() => _isCapturandoFoto = true);
    try {
      final captured = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 75,
        maxWidth: 1920,
      );
      if (captured == null) return;

      final savedPath = await _persistirEvidencia(
        captured.path,
        prefixo: isAntes ? 'antes' : 'depois',
      );

      if (!mounted) return;
      setState(() {
        if (isAntes) {
          _fotoAntesPath = savedPath;
        } else {
          _fotoDepoisPath = savedPath;
        }
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Nao foi possivel capturar a foto.'),
            backgroundColor: Colors.red,
          ),
        );
    } finally {
      if (mounted) {
        setState(() => _isCapturandoFoto = false);
      }
    }
  }

  Future<String> _persistirEvidencia(
    String origemPath, {
    required String prefixo,
  }) async {
    final docs = await getApplicationDocumentsDirectory();
    final pastaEvidencias = Directory(p.join(docs.path, 'evidencias_os'));
    if (!await pastaEvidencias.exists()) {
      await pastaEvidencias.create(recursive: true);
    }

    final extensao = p.extension(origemPath).isEmpty
        ? '.jpg'
        : p.extension(origemPath);
    final nomeArquivo =
        '${prefixo}_${DateTime.now().millisecondsSinceEpoch}$extensao';
    final destino = p.join(pastaEvidencias.path, nomeArquivo);

    final arquivoCopiado = await File(origemPath).copy(destino);
    return arquivoCopiado.path;
  }

  Widget _buildFotoField({
    required String titulo,
    required String? caminhoFoto,
    required VoidCallback onCapture,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        if (caminhoFoto == null)
          const Text('Nenhuma foto capturada.')
        else
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(caminhoFoto),
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 120,
                width: double.infinity,
                color: Colors.black12,
                alignment: Alignment.center,
                child: const Text('Nao foi possivel exibir a foto.'),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: OutlinedButton.icon(
            onPressed: _isCapturandoFoto ? null : onCapture,
            icon: _isCapturandoFoto
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.camera_alt_outlined),
            label: Text(
              caminhoFoto == null ? 'Capturar foto' : 'Trocar foto',
            ),
          ),
        ),
      ],
    );
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
            final clienteSelecionadoValido = _controller.clientesDisponiveis
                .any((item) => item.id == _selectedClienteId);
            final tecnicoSelecionadoValido = _controller.tecnicosDisponiveis
                .any((item) => item.id == _selectedTecnicoId);

            final clienteAtual =
                clienteSelecionadoValido ? _selectedClienteId : null;
            final tecnicoAtual =
                tecnicoSelecionadoValido ? _selectedTecnicoId : null;

            return Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CustomDropdownField<int>(
                            label: 'Cliente',
                            hint: _controller.clientesDisponiveis.isEmpty
                                ? 'Cadastre clientes ativos primeiro'
                                : 'Selecione um cliente',
                            value: clienteAtual,
                            items: _controller.clientesDisponiveis
                                .map(
                                  (cliente) => DropdownMenuItem<int>(
                                    value: cliente.id,
                                    child:
                                        Text('${cliente.id} - ${cliente.nome}'),
                                  ),
                                )
                                .toList(),
                            isEnabled: _controller.clientesDisponiveis.isNotEmpty,
                            onChanged: (value) {
                              setState(() => _selectedClienteId = value);
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomDropdownField<int>(
                            label: 'Tecnico',
                            hint: _controller.tecnicosDisponiveis.isEmpty
                                ? 'Cadastre tecnicos ativos primeiro'
                                : 'Selecione um tecnico',
                            value: tecnicoAtual,
                            items: _controller.tecnicosDisponiveis
                                .map(
                                  (tecnico) => DropdownMenuItem<int>(
                                    value: tecnico.id,
                                    child:
                                        Text('${tecnico.id} - ${tecnico.nome}'),
                                  ),
                                )
                                .toList(),
                            isEnabled: _controller.tecnicosDisponiveis.isNotEmpty,
                            onChanged: (value) {
                              setState(() => _selectedTecnicoId = value);
                            },
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
                          const SizedBox(height: 12),
                          _buildFotoField(
                            titulo: 'Foto antes',
                            caminhoFoto: _fotoAntesPath,
                            onCapture: () => _capturarFoto(isAntes: true),
                          ),
                          const SizedBox(height: 12),
                          _buildFotoField(
                            titulo: 'Foto depois',
                            caminhoFoto: _fotoDepoisPath,
                            onCapture: () => _capturarFoto(isAntes: false),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _controller.isLoading ||
                                      _controller.clientesDisponiveis.isEmpty ||
                                      _controller.tecnicosDisponiveis.isEmpty ||
                                      _isCapturandoFoto
                                  ? null
                                  : _salvarOrdem,
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
                                    '\nFoto antes: ${ordem.fotoAntes?.isNotEmpty == true ? 'Sim' : 'Nao'}'
                                    '\nFoto depois: ${ordem.fotoDepois?.isNotEmpty == true ? 'Sim' : 'Nao'}'
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
