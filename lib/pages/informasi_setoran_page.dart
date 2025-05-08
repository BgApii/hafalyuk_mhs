import 'package:flutter/material.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';

class InformasiSetoranPage extends StatelessWidget {
  final Setoran? setoran;

  const InformasiSetoranPage({super.key, this.setoran});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informasi Setoran'), centerTitle: true),
      body: Container(
        width: double.infinity,
        height: double.infinity, // Container takes full screen height
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
        child: SingleChildScrollView(
          // Allows content to scroll if needed
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xFFD9D9D9), width: 1.0),
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Column takes minimum height
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoItem(
                      icon: Icons.account_balance_wallet,
                      label: 'Total Wajib Setor',
                      value:
                          setoran?.infoDasar!.totalWajibSetor.toString() ?? '0',
                    ),
                    InfoItem(
                      icon: Icons.check_circle,
                      label: 'Total Sudah Setor',
                      value:
                          setoran?.infoDasar!.totalSudahSetor.toString() ?? '0',
                    ),
                    InfoItem(
                      icon: Icons.pending,
                      label: 'Total Belum Setor',
                      value:
                          setoran?.infoDasar!.totalBelumSetor.toString() ?? '0',
                    ),
                    InfoItem(
                      icon: Icons.trending_up,
                      label: 'Progres Setoran',
                      value:
                          '${setoran?.infoDasar!.persentaseProgresSetor ?? 0}%',
                    ),
                    InfoItem(
                      icon: Icons.calendar_today,
                      label: 'Terakhir Setor',
                      value: setoran?.infoDasar!.terakhirSetor ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

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
                  value,
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
