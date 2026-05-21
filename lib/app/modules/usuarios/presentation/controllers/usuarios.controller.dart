import 'package:serviceflow/app/core/base/base.controller.dart';

import '../../data/usuario.repository.dart';
import '../../domain/usuario.service.dart';
import '../../domain/usuario.validation.dart';
import '../../usuario.model.dart';

class UsuariosController extends BaseController<Usuario, UsuarioRepository,
    UsuarioValidation, UsuarioService> {
  UsuariosController({
    required UsuarioService service,
  }) : super(service);

  final List<Usuario> _usuarios = [];

  List<Usuario> get usuarios => List.unmodifiable(_usuarios);

  Future<void> loadUsuarios() async {
    final data = await executeOperation<List<Usuario>>(
      () => service.findAll(),
      errorMessage: 'Falha ao carregar usuarios.',
    );

    if (data == null) return;
    _usuarios
      ..clear()
      ..addAll(data);
    notifyListeners();
  }

  Future<bool> cadastrarUsuario({
    required String nomeCompleto,
    required String email,
    required String grupoId,
    required String perfil,
  }) async {
    final agora = DateTime.now();
    final usuario = Usuario(
      nomeCompleto: nomeCompleto.trim(),
      email: email.trim(),
      grupoId: grupoId.trim(),
      perfil: perfil.trim().isEmpty ? 'tecnico' : perfil.trim(),
      supabaseId: 'local_${agora.microsecondsSinceEpoch}',
      ultimoLogin: agora,
      isSync: 0,
      createdAt: agora,
    );

    final created = await executeOperation<int>(
      () => service.create(usuario),
      successMessage: 'Usuario salvo localmente.',
      errorMessage: 'Nao foi possivel salvar o usuario.',
    );

    if (created == null) return false;

    await loadUsuarios();
    return true;
  }

  Future<void> removerUsuario(int id) async {
    await executeCrudOperation(
      () async {
        await service.delete(id);
        await loadUsuarios();
      },
      successMessage: 'Usuario removido com sucesso.',
      errorMessage: 'Falha ao remover usuario.',
    );
  }
}
