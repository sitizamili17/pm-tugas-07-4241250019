import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import 'data_contoh.dart';
import 'halaman_daftar.dart';
import 'halaman_form.dart';
import 'halaman_statistik.dart';
import 'planner_model.dart';

/// Satu-satunya seed color tema aplikasi.
const Color _warnaSeed = Color(0xFF3F51B5);

void main() => runApp(
      // Satu PlannerModel untuk seluruh aplikasi, diletakkan di atas MaterialApp.
      ChangeNotifierProvider(
        create: (_) => PlannerModel(awal: dataContoh()),
        child: const PlannerApp(),
      ),
    );

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => KerangkaNavigasi(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HalamanDaftar(),
              routes: [
                GoRoute(
                  path: 'tambah', // URL lengkap: /tambah
                  builder: (context, state) => const HalamanForm(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/statistik',
              builder: (context, state) => const HalamanStatistik(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class PlannerApp extends StatelessWidget {
  const PlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Planner Tugas Kuliah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _warnaSeed),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: _warnaSeed,
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: _router,
    );
  }
}

/// Kerangka navigasi: NavigationBar di ponsel, NavigationRail di layar lebar.
class KerangkaNavigasi extends StatelessWidget {
  const KerangkaNavigasi({super.key, required this.shell});

  final StatefulNavigationShell shell;

  void _pilih(int i) =>
      shell.goBranch(i, initialLocation: i == shell.currentIndex);

  @override
  Widget build(BuildContext context) {
    final lebar = MediaQuery.sizeOf(context).width;

    // select: dibangun ulang hanya bila jumlah tugas aktif berubah.
    final aktif = context.select((PlannerModel p) => p.jumlahAktif);

    final ikonTugas = Badge.count(
      count: aktif,
      isLabelVisible: aktif > 0,
      child: const Icon(Icons.checklist_outlined),
    );
    final ikonTugasDipilih = Badge.count(
      count: aktif,
      isLabelVisible: aktif > 0,
      child: const Icon(Icons.checklist),
    );

    // Layar lebar (>= 840 dp): navigasi di samping
    if (lebar >= 840) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _pilih,
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: ikonTugas,
                  selectedIcon: ikonTugasDipilih,
                  label: const Text('Tugas'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: Text('Statistik'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }

    // Layar sempit (ponsel): navigasi di bawah
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _pilih,
        destinations: [
          NavigationDestination(
            icon: ikonTugas,
            selectedIcon: ikonTugasDipilih,
            label: 'Tugas',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}