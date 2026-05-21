import '../../modules/clientes/cliente.model.dart';
import '../../modules/clientes/data/cliente.repository.dart';
import '../../modules/ordens_servico/data/ordem_servico.repository.dart';
import '../../modules/ordens_servico/ordem_servico.model.dart';
import '../../modules/tecnicos/data/tecnico.repository.dart';
import '../../modules/tecnicos/tecnico.model.dart';

class DemoSeedResult {
  const DemoSeedResult({
    required this.clientesCriados,
    required this.tecnicosCriados,
    required this.ordensCriadas,
  });

  final int clientesCriados;
  final int tecnicosCriados;
  final int ordensCriadas;
}

class DemoSeedService {
  DemoSeedService({
    ClienteRepository? clienteRepository,
    TecnicoRepository? tecnicoRepository,
    OrdemServicoRepository? ordemServicoRepository,
  })  : _clienteRepository = clienteRepository ?? ClienteRepository(),
        _tecnicoRepository = tecnicoRepository ?? TecnicoRepository(),
        _ordemServicoRepository = ordemServicoRepository ?? OrdemServicoRepository();

  final ClienteRepository _clienteRepository;
  final TecnicoRepository _tecnicoRepository;
  final OrdemServicoRepository _ordemServicoRepository;

  Future<DemoSeedResult> seedBasicData() async {
    var clientesCriados = 0;
    var tecnicosCriados = 0;
    var ordensCriadas = 0;

    final cliente = await _getOrCreateCliente();
    if (cliente.created) clientesCriados++;

    final tecnico = await _getOrCreateTecnico();
    if (tecnico.created) tecnicosCriados++;

    final clienteId = cliente.entity.id;
    final tecnicoId = tecnico.entity.id;

    if (clienteId == null || tecnicoId == null) {
      throw Exception('Nao foi possivel preparar referencias de cliente/tecnico.');
    }

    final ordem = OrdemServico(
      clienteId: clienteId,
      tecnicoId: tecnicoId,
      observacao: 'O.S. de demonstracao offline-first',
      valorPecas: 149.90,
      isSync: 0,
      createdAt: DateTime.now(),
    );

    await _ordemServicoRepository.insert(ordem);
    ordensCriadas++;

    return DemoSeedResult(
      clientesCriados: clientesCriados,
      tecnicosCriados: tecnicosCriados,
      ordensCriadas: ordensCriadas,
    );
  }

  Future<_SeedEntityResult<Cliente>> _getOrCreateCliente() async {
    const email = 'demo.cliente@serviceflow.app';
    final existente = await _clienteRepository.findByEmail(email);
    if (existente != null) {
      return _SeedEntityResult(entity: existente, created: false);
    }

    final cliente = Cliente(
      nome: 'Cliente Demonstracao',
      email: email,
      telefone: '(11) 90000-0001',
      isSync: 0,
      createdAt: DateTime.now(),
    );
    final id = await _clienteRepository.insert(cliente);
    final criado = Cliente(
      id: id,
      nome: cliente.nome,
      email: cliente.email,
      telefone: cliente.telefone,
      isSync: cliente.isSync,
      createdAt: cliente.createdAt,
    );
    return _SeedEntityResult(entity: criado, created: true);
  }

  Future<_SeedEntityResult<Tecnico>> _getOrCreateTecnico() async {
    const nome = 'Tecnico Demonstracao';
    final existente = await _tecnicoRepository.findByNome(nome);
    if (existente != null) {
      return _SeedEntityResult(entity: existente, created: false);
    }

    final tecnico = Tecnico(
      nome: nome,
      especialidade: 'Equipamentos Industriais',
      ativo: 1,
      isSync: 0,
      createdAt: DateTime.now(),
    );
    final id = await _tecnicoRepository.insert(tecnico);
    final criado = Tecnico(
      id: id,
      nome: tecnico.nome,
      especialidade: tecnico.especialidade,
      ativo: tecnico.ativo,
      isSync: tecnico.isSync,
      createdAt: tecnico.createdAt,
    );
    return _SeedEntityResult(entity: criado, created: true);
  }
}

class _SeedEntityResult<T> {
  const _SeedEntityResult({
    required this.entity,
    required this.created,
  });

  final T entity;
  final bool created;
}
