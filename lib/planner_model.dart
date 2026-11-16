import 'package:flutter/foundation.dart';

/// Satu tugas kuliah. Immutable: perubahan dilakukan lewat copyWith.
class TugasKuliah {
  const TugasKuliah({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
    this.selesai = false,
  });

  final int id;
  final String judul;
  final String mataKuliah;
  final DateTime tenggat;
  final bool selesai;

  TugasKuliah copyWith({bool? selesai}) => TugasKuliah(
    id: id,
    judul: judul,
    mataKuliah: mataKuliah,
    tenggat: tenggat,
    selesai: selesai ?? this.selesai,
  );
}

/// Pilihan filter pada halaman daftar.
enum FilterTugas { semua, aktif, selesai }

/// State bersama. Tidak mengimpor pustaka UI, jadi mudah diuji.
class PlannerModel extends ChangeNotifier {
  PlannerModel({List<TugasKuliah> awal = const []})
    : _daftar = List.of(awal),
      _idBerikut = awal.fold(0, (maks, t) => t.id > maks ? t.id : maks) + 1;

  final List<TugasKuliah> _daftar; // privat: hanya diubah lewat method di bawah
  int _idBerikut;

  /// Daftar urut dari tenggat terdekat (salinan, tidak bisa diubah dari luar).
  List<TugasKuliah> get daftar {
    final salinan = List.of(_daftar)
      ..sort((a, b) {
        final urut = a.tenggat.compareTo(b.tenggat);
        return urut != 0 ? urut : a.id.compareTo(b.id);
      });
    return List.unmodifiable(salinan);
  }

  int get total => _daftar.length;
  int get jumlahSelesai => _daftar.where((t) => t.selesai).length;
  int get jumlahAktif => total - jumlahSelesai;

  /// Persentase tugas selesai (0 sampai 100); 0 bila belum ada tugas.
  double get persenSelesai => total == 0 ? 0 : jumlahSelesai * 100 / total;

  /// Daftar yang sudah disaring menurut [filter].
  List<TugasKuliah> saring(FilterTugas filter) => switch (filter) {
    FilterTugas.semua => daftar,
    FilterTugas.aktif => daftar.where((t) => !t.selesai).toList(),
    FilterTugas.selesai => daftar.where((t) => t.selesai).toList(),
  };

  void tambah({
    required String judul,
    required String mataKuliah,
    required DateTime tenggat,
  }) {
    _daftar.add(
      TugasKuliah(
        id: _idBerikut++,
        judul: judul.trim(),
        mataKuliah: mataKuliah.trim(),
        tenggat: tenggat,
      ),
    );
    notifyListeners(); // beri tahu semua widget yang mendengarkan
  }

  void tandaiSelesai(int id, {required bool selesai}) {
    final i = _daftar.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _daftar[i] = _daftar[i].copyWith(selesai: selesai);
    notifyListeners();
  }

  void hapus(int id) {
    final sebelum = _daftar.length;
    _daftar.removeWhere((t) => t.id == id);
    if (_daftar.length != sebelum) notifyListeners();
  }
}
