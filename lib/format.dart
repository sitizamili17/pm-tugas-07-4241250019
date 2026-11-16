const _bulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// 2026-11-20 menjadi "20 Nov 2026".
String tanggalSingkat(DateTime d) =>
    '${d.day} ${_bulan[d.month - 1]} ${d.year}';
