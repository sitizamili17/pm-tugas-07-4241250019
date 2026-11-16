import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'format.dart';
import 'planner_model.dart';

String _namaFilter(FilterTugas f) => switch (f) {
      FilterTugas.semua => 'Semua',
      FilterTugas.aktif => 'Aktif',
      FilterTugas.selesai => 'Selesai',
    };

class HalamanDaftar extends StatefulWidget {
  const HalamanDaftar({super.key});

  @override
  State<HalamanDaftar> createState() => _HalamanDaftarState();
}

class _HalamanDaftarState extends State<HalamanDaftar> {
  // Ephemeral state: hanya dipakai halaman ini, jadi cukup setState.
  FilterTugas _filter = FilterTugas.semua;

  @override
  Widget build(BuildContext context) {
    // watch: halaman dibangun ulang setiap PlannerModel berubah.
    final planner = context.watch<PlannerModel>();
    final tampil = planner.saring(_filter);

    return Scaffold(
      appBar: AppBar(title: const Text('Planner Tugas')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/tambah'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Center(
        child: ConstrainedBox(
          // Dibatasi supaya tetap rapi di layar lebar.
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    children: [
                      for (final f in FilterTugas.values)
                        FilterChip(
                          label: Text(_namaFilter(f)),
                          selected: _filter == f,
                          onSelected: (_) => setState(() => _filter = f),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: tampil.isEmpty
                    ? _DaftarKosong(filter: _filter)
                    : ListView.builder(
                        // Ruang bawah supaya tombol Tambah tidak menutupi item
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 88),
                        itemCount: tampil.length,
                        itemBuilder: (context, i) => KartuTugas(
                          key: ValueKey(tampil[i].id),
                          tugas: tampil[i],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Satu tugas pada daftar. Stateless: semua perubahan lewat PlannerModel.
class KartuTugas extends StatelessWidget {
  const KartuTugas({super.key, required this.tugas});

  final TugasKuliah tugas;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;

    final sekarang = DateTime.now();
    final awalHari = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final terlambat = !tugas.selesai && tugas.tenggat.isBefore(awalHari);
    final penanda = terlambat ? ' · Terlambat' : '';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: tugas.selesai,
          // read di dalam callback: tidak perlu mendengarkan
          onChanged: (nilai) => context
              .read<PlannerModel>()
              .tandaiSelesai(tugas.id, selesai: nilai ?? false),
        ),
        title: Text(
          tugas.judul,
          style: tugas.selesai
              ? TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: skema.onSurfaceVariant,
                )
              : null,
        ),
        subtitle: Text(
          '${tugas.mataKuliah} · ${tanggalSingkat(tugas.tenggat)}$penanda',
          style: terlambat ? TextStyle(color: skema.error) : null,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Hapus',
          onPressed: () => context.read<PlannerModel>().hapus(tugas.id),
        ),
      ),
    );
  }
}

class _DaftarKosong extends StatelessWidget {
  const _DaftarKosong({required this.filter});

  final FilterTugas filter;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    final pesan = switch (filter) {
      FilterTugas.semua => 'Belum ada tugas. Ketuk Tambah untuk membuat.',
      FilterTugas.aktif => 'Tidak ada tugas aktif.',
      FilterTugas.selesai => 'Belum ada tugas yang selesai.',
    };

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 56, color: skema.outline),
          const SizedBox(height: 12),
          Text(pesan),
        ],
      ),
    );
  }
}