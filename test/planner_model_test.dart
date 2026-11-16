import 'package:flutter_test/flutter_test.dart';
import 'package:pm_tugas_07_4241250019/planner_model.dart';

void main() {
  late PlannerModel model;

  setUp(() {
    model = PlannerModel();
  });

  /// Menambah tugas contoh; [hari] mengatur tanggal tenggat.
  void tambahContoh(String judul, {int hari = 20}) {
    model.tambah(
      judul: judul,
      mataKuliah: 'Pemrograman Mobile',
      tenggat: DateTime(2026, 11, hari),
    );
  }

  test('tambah menyimpan tugas, memberi id berurutan, dan memberi notifikasi',
      () {
    var notifikasi = 0;
    model.addListener(() => notifikasi++);

    tambahContoh('Laporan praktikum', hari: 20);
    tambahContoh('Kuis Dart', hari: 25);

    expect(model.total, 2);
    expect(model.daftar.map((t) => t.id).toList(), [1, 2]);
    expect(notifikasi, 2);
  });

  test('tandaiSelesai memperbarui jumlah dan persentase', () {
    tambahContoh('A', hari: 20);
    tambahContoh('B', hari: 21);
    tambahContoh('C', hari: 22);
    tambahContoh('D', hari: 23);

    model.tandaiSelesai(1, selesai: true);
    expect(model.jumlahSelesai, 1);
    expect(model.jumlahAktif, 3);
    expect(model.persenSelesai, 25);

    model.tandaiSelesai(1, selesai: false);
    expect(model.jumlahSelesai, 0);
    expect(model.persenSelesai, 0);
  });

  test('hapus menghapus tugas dan mengabaikan id yang tidak ada', () {
    tambahContoh('A', hari: 20);
    tambahContoh('B', hari: 21);

    var notifikasi = 0;
    model.addListener(() => notifikasi++);

    model.hapus(1);
    expect(model.total, 1);
    expect(notifikasi, 1);

    model.hapus(99); // id tidak ada: tidak berubah dan tidak ada notifikasi
    expect(model.total, 1);
    expect(notifikasi, 1);
  });

  test('saring memisahkan tugas aktif dan selesai', () {
    tambahContoh('A', hari: 20);
    tambahContoh('B', hari: 21);
    tambahContoh('C', hari: 22);
    model.tandaiSelesai(2, selesai: true);

    expect(model.saring(FilterTugas.semua).length, 3);
    expect(
      model.saring(FilterTugas.aktif).map((t) => t.judul).toList(),
      ['A', 'C'],
    );
    expect(
      model.saring(FilterTugas.selesai).map((t) => t.judul).toList(),
      ['B'],
    );
  });

  test('daftar terurut dari tenggat terdekat dan persen 0 saat kosong', () {
    expect(model.persenSelesai, 0);

    tambahContoh('Terakhir', hari: 28);
    tambahContoh('Pertama', hari: 12);

    expect(model.daftar.first.judul, 'Pertama');
  });
}