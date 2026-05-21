import 'package:flutter/material.dart';

import '../../../../app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ServiceFlow - Dashboard')),
      body: SafeArea(
        child: GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: const [
            _MenuCard(
              titulo: 'Clientes',
              icone: Icons.people_alt_outlined,
              rota: AppRoutes.clientes,
            ),
            _MenuCard(
              titulo: 'Ordem de Servico',
              icone: Icons.assignment_turned_in_outlined,
              rota: AppRoutes.ordensServico,
            ),
            _MenuCard(
              titulo: 'Relatorios',
              icone: Icons.bar_chart_rounded,
              rota: AppRoutes.relatorios,
            ),
            _MenuCard(
              titulo: 'Laboratorio',
              icone: Icons.science_rounded,
              rota: AppRoutes.laboratorio,
            ),
            _MenuCard(
              titulo: 'Estoque',
              icone: Icons.inventory_2_outlined,
              rota: AppRoutes.estoque,
            ),
            _MenuCard(
              titulo: 'Configuracoes',
              icone: Icons.settings_outlined,
              rota: AppRoutes.configuracoes,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String titulo;
  final IconData icone;
  final String rota;

  const _MenuCard({
    required this.titulo,
    required this.icone,
    required this.rota,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, rota),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icone, size: 38),
              const SizedBox(height: 10),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
