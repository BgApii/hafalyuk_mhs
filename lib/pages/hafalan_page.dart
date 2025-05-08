import 'package:flutter/material.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/services/auth_service.dart';
import 'package:hafalyuk_mhs/services/hafalan_service.dart';
import 'package:hafalyuk_mhs/pages/login_page.dart';

class HafalanPage extends StatefulWidget {
  const HafalanPage({super.key});

  @override
  _HafalanPageState createState() => _HafalanPageState();
}

class _HafalanPageState extends State<HafalanPage> {
  late final AuthService authService;
  late final SetoranService setoranService;
  late Future<SetoranMhs> _setoranFuture;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    setoranService = SetoranService(authService);
    _setoranFuture = setoranService.getSetoranData();
  }

  Future<void> _refreshData() async {
    setState(() {
      _setoranFuture = setoranService.getSetoranData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Setoran Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<SetoranMhs>(
          future: _setoranFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              if (snapshot.error.toString().contains('Session expired')) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sesi Anda telah berakhir. Silakan login kembali.'),
                    ),
                  );
                });
                return const Center(child: Text('Mengalihkan ke halaman login...'));
              }
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData ||
                snapshot.data!.response != true ||
                snapshot.data!.data == null) {
              return const Center(child: Text('No data available'));
            }

            final setoranData = snapshot.data!.data!;
            final info = setoranData.info;
            final setoran = setoranData.setoran;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(), // Pastikan scroll selalu aktif
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Mahasiswa',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nama: ${info?.nama ?? "N/A"}'),
                            Text('NIM: ${info?.nim ?? "N/A"}'),
                            Text('Email: ${info?.email ?? "N/A"}'),
                            Text('Angkatan: ${info?.angkatan ?? "N/A"}'),
                            Text('Semester: ${info?.semester?.toString() ?? "N/A"}'),
                            Text('Dosen PA: ${info?.dosenPa?.nama ?? "N/A"}'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Informasi Setoran',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (setoran != null && setoran.infoDasar != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Wajib Setor: ${setoran.infoDasar!.totalWajibSetor ?? 0}'),
                              Text('Total Sudah Setor: ${setoran.infoDasar!.totalSudahSetor ?? 0}'),
                              Text('Total Belum Setor: ${setoran.infoDasar!.totalBelumSetor ?? 0}'),
                              Text('Progres Setoran: ${setoran.infoDasar!.persentaseProgresSetor ?? 0}%'),
                              Text('Terakhir Setor: ${setoran.infoDasar!.terakhirSetor ?? "N/A"}'),
                            ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Ringkasan Setoran',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (setoran == null || setoran.ringkasan == null || setoran.ringkasan!.isEmpty)
                      const Text('Belum ada ringkasan setoran.')
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: setoran.ringkasan!.length,
                        itemBuilder: (context, index) {
                          final ringkasan = setoran.ringkasan![index];
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Label: ${ringkasan.label ?? "N/A"}'),
                                  Text('Total Wajib Setor: ${ringkasan.totalWajibSetor ?? 0}'),
                                  Text('Total Sudah Setor: ${ringkasan.totalSudahSetor ?? 0}'),
                                  Text('Total Belum Setor: ${ringkasan.totalBelumSetor ?? 0}'),
                                  Text('Progres Setoran: ${ringkasan.persentaseProgresSetor ?? 0}%'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Detail Setoran',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    if (setoran == null || setoran.detail == null || setoran.detail!.isEmpty)
                      const Text('Belum ada detail setoran.')
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: setoran.detail!.length,
                        itemBuilder: (context, index) {
                          final detail = setoran.detail![index];
                          return ListTile(
                            title: Text('${detail.nama ?? "N/A"} - ${detail.label ?? "N/A"}'),
                            subtitle: Text('Sudah Setor: ${detail.sudahSetor == true ? "Ya" : "Belum"}'),
                          );
                        },
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}