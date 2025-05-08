import 'package:flutter/material.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/pages/detail_setoran_page.dart';
import 'package:hafalyuk_mhs/pages/informasi_setoran_page.dart';
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
      drawer: FutureBuilder<SetoranMhs>(
        future: _setoranFuture,
        builder: (context, snapshot) {
          String name = "Unknown Name";
          String nim = "Unknown NIM";
          if (snapshot.hasData &&
              snapshot.data!.response == true &&
              snapshot.data!.data != null) {
            final info = snapshot.data!.data!.info;
            name = info?.nama ?? "Unknown Name";
            nim = info?.nim ?? "Unknown NIM";
          }
          return Drawer(
            child: Column(
              children: [
                // Header tanpa gambar
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, top: 70, bottom: 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1976D2), Color(0xFF0D47A1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        nim,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // Menu
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text("Informasi Mahasiswa"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text("Informasi Setoran"),
                  onTap: () async{
                    Navigator.pop(context); // Close the drawer
                    final setoranMhs = await _setoranFuture;
                    if (setoranMhs.response == true && setoranMhs.data != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformasiSetoranPage(setoran: setoranMhs.data!.setoran),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal memuat data setoran.')),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.list),
                  title: const Text("Detail Setoran"),
                  onTap: () async{
                    Navigator.pop(context); // Close the drawer
                    final setoranMhs = await _setoranFuture;
                    if (setoranMhs.response == true && setoranMhs.data != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailSetoranPage(setoran: setoranMhs.data!.setoran),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gagal memuat detail setoran.')),
                      );
                    }
                  },
                ),
                const Spacer(),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Keluar"),
                  onTap: () async {
                    await authService.logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Informasi Mahasiswa'),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFFFFF), // Warna atas
              Color(0xFF53AAD9), // Warna bawah
            ],
          ),
        ),
        child: RefreshIndicator(
          color: Colors.blueAccent,
          onRefresh: _refreshData,
          child: FutureBuilder<SetoranMhs>(
            future: _setoranFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                );
              } else if (snapshot.hasError) {
                if (snapshot.error.toString().contains('Session expired')) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Sesi Anda telah berakhir. Silakan login kembali.',
                        ),
                      ),
                    );
                  });
                  return const Center(
                    child: Text('Mengalihkan ke halaman login...'),
                  );
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
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: Color(0xFFD9D9D9),
                              width: 1,
                            ),
                          ),
                          elevation: 2,

                          color: const Color(0xFFF9FAFB),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InfoItem(
                                  icon: Icons.person,
                                  label: 'Nama',
                                  value: info?.nama,
                                ),
                                InfoItem(
                                  icon: Icons.badge,
                                  label: 'NIM',
                                  value: info?.nim,
                                ),
                                InfoItem(
                                  icon: Icons.email,
                                  label: 'Email',
                                  value: info?.email,
                                ),
                                Divider(color: Colors.grey[300], thickness: 1),
                                InfoItem(
                                  icon: Icons.school,
                                  label: 'Angkatan',
                                  value: info?.angkatan,
                                ),
                                InfoItem(
                                  icon: Icons.calendar_today,
                                  label: 'Semester',
                                  value: info?.semester?.toString(),
                                ),
                                InfoItem(
                                  icon: Icons.supervisor_account,
                                  label: 'Dosen PA',
                                  value: info?.dosenPa?.nama,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const InfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value ?? 'N/A',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
