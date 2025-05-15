import 'package:flutter/material.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/pages/detail_page.dart';
import 'package:hafalyuk_mhs/pages/informasi_setoran_page.dart';
import 'package:hafalyuk_mhs/pages/login_page.dart';
import 'package:hafalyuk_mhs/services/auth_service.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.name,
    required this.nim,
    required Future<SetoranMhs> setoranFuture,
    required this.authService,
  }) : _setoranFuture = setoranFuture;

  final String name;
  final String nim;
  final Future<SetoranMhs> _setoranFuture;
  final AuthService authService;

  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => DetailPage(setoran: setoranMhs.data!.setoran, filterLabel: '',),
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
  }
}
