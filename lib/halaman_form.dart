import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'format.dart';
import 'planner_model.dart';

class HalamanForm extends StatefulWidget {
  const HalamanForm({super.key});

  @override
  State<HalamanForm> createState() => _HalamanFormState();
}

class _HalamanFormState extends State<HalamanForm> {
  final _kunciForm = GlobalKey<FormState>();
  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  DateTime? _tenggat; // ephemeral state: tanggal yang dipilih

  @override
  void initState() {
    super.initState();
    // Dibuat sekali, saat State dibuat.
    _judul = TextEditingController();
    _mataKuliah = TextEditingController();
  }

  @override
  void dispose() {
    // Wajib dibuang supaya tidak terjadi kebocoran memori.
    _judul.dispose();
    _mataKuliah.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final sekarang = DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);

    final hasil = await showDatePicker(
      context: context,
      initialDate: _tenggat ?? hariIni,
      firstDate: hariIni,
      lastDate: DateTime(sekarang.year + 2),
    );

    // Halaman mungkin sudah ditutup selama pengguna memilih tanggal.
    if (!mounted) return;
    if (hasil != null) setState(() => _tenggat = hasil);
  }

  void _simpan() {
    final valid = _kunciForm.currentState?.validate() ?? false;
    if (!valid) return;

    final tenggat = _tenggat;
    if (tenggat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal tenggat dulu')),
      );
      return;
    }

    context.read<PlannerModel>().tambah(
          judul: _judul.text,
          mataKuliah: _mataKuliah.text,
          tenggat: tenggat,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tugas ditambahkan')),
    );

    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }

  String? _wajibIsi(String? nilai, String pesan) =>
      (nilai == null || nilai.trim().isEmpty) ? pesan : null;

  @override
  Widget build(BuildContext context) {
    final tenggat = _tenggat;
    final labelTanggal =
        tenggat == null ? 'Pilih tenggat' : tanggalSingkat(tenggat);

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Form(
                key: _kunciForm,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _judul,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Judul tugas',
                        border: OutlineInputBorder(),
                      ),
                      validator: (nilai) =>
                          _wajibIsi(nilai, 'Judul wajib diisi'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _mataKuliah,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Mata kuliah',
                        border: OutlineInputBorder(),
                      ),
                      validator: (nilai) =>
                          _wajibIsi(nilai, 'Mata kuliah wajib diisi'),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: _pilihTanggal,
                        icon: const Icon(Icons.event),
                        label: Text(labelTanggal),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _simpan,
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}