import 'package:serviceflow/app/core/base/base.controller.dart';

import '../../cliente.model.dart';
import '../../data/cliente.repository.dart';
import '../../domain/cliente.service.dart';
import '../../domain/cliente.validation.dart';

class ClientesController extends BaseController<Cliente, ClienteRepository,
    ClienteValidation, ClienteService> {
  ClientesController({
    required ClienteService service,
  }) : super(service);

  final List<Cliente> _clientes = [];

  List<Cliente> get clientes => List.unmodifiable(_clientes);

  Future<void> loadClientes() async {
    final data = await executeOperation<List<Cliente>>(
      () => service.findAll(),
      errorMessage: 'Falha ao carregar clientes.',
    );

    if (data == null) return;
    _clientes
      ..clear()
      ..addAll(data);
    notifyListeners();
  }

  Future<bool> cadastrarCliente({
    required String nome,
    required String email,
    required String telefone,
  }) async {
    final novoCliente = Cliente(
      nome: nome.trim(),
      email: email.trim(),
      telefone: telefone.trim(),
      isSync: 0,
      createdAt: DateTime.now(),
    );

    final created = await executeOperation<int>(
      () => service.create(novoCliente),
      successMessage: 'Cliente salvo localmente.',
      errorMessage: 'Nao foi possivel salvar o cliente.',
    );

    if (created == null) return false;

    await loadClientes();
    return true;
  }

  Future<void> removerCliente(int id) async {
    await executeCrudOperation(
      () async {
        await service.delete(id);
        await loadClientes();
      },
      successMessage: 'Cliente removido com sucesso.',
      errorMessage: 'Falha ao remover cliente.',
    );
  }
}
