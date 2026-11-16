import 'planner_model.dart';

/// Data awal contoh, tenggatnya dihitung dari hari ini.
List<TugasKuliah> dataContoh() {
  final sekarang = DateTime.now();
  DateTime hari(int tambah) =>
      DateTime(sekarang.year, sekarang.month, sekarang.day + tambah);

  return [
    TugasKuliah(
      id: 1,
      judul: 'Tugas Rutin 7',
      mataKuliah: 'Pemrograman Mobile',
      tenggat: hari(6),
    ),
    TugasKuliah(
      id: 2,
      judul: 'Laporan praktikum jaringan',
      mataKuliah: 'Jaringan Komputer',
      tenggat: hari(2),
    ),
    TugasKuliah(
      id: 3,
      judul: 'Latihan soal basis data',
      mataKuliah: 'Basis Data',
      tenggat: hari(4),
      selesai: true,
    ),
    TugasKuliah(
      id: 4,
      judul: 'Ringkasan jurnal CJR',
      mataKuliah: 'Pemrograman Mobile',
      tenggat: hari(9),
    ),
  ];
}
