import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'planner_model.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: angka otomatis berubah saat tugas ditambah, diselesaikan, atau dihapus.
    final p = context.watch<PlannerModel>();
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: _KartuAngka(
                      ikon: Icons.list_alt,
                      label: 'Total',
                      nilai: '${p.total}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KartuAngka(
                      ikon: Icons.task_alt,
                      label: 'Selesai',
                      nilai: '${p.jumlahSelesai}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _KartuAngka(
                      ikon: Icons.pending_actions,
                      label: 'Aktif',
                      nilai: '${p.jumlahAktif}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Progres penyelesaian', style: teks.titleMedium),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: p.persenSelesai / 100,
                  minHeight: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${p.persenSelesai.toStringAsFixed(0)}% tugas sudah selesai',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KartuAngka extends StatelessWidget {
  const _KartuAngka({
    required this.ikon,
    required this.label,
    required this.nilai,
  });

  final IconData ikon;
  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final teks = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(ikon, color: skema.primary),
            const SizedBox(height: 8),
            Text(nilai, style: teks.headlineMedium),
            Text(
              label,
              style: teks.bodySmall?.copyWith(color: skema.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
