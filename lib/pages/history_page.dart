import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';

class HistoryPage extends StatelessWidget {
  final Future<SetoranMhs> setoranFuture;

  const HistoryPage({super.key, required this.setoranFuture});

  String _formatDate(String? timestamp) {
    if (timestamp == null) return 'N/A';
    try {
      final dateTime = DateTime.parse(timestamp);
      final List<String> months = [
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember',
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
    } catch (e) {
      return 'N/A';
    }
  }

  String _extractSurah(String? keterangan, String? aksi) {
    if (keterangan == null || keterangan.isEmpty) return 'N/A';
    if (aksi == 'VALIDASI') {
      // For VALIDASI, keterangan is like "An-Naba', serta memilih tanggal muroja'ah undefined"
      final parts = keterangan.split(', serta');
      return parts.isNotEmpty ? parts[0].trim() : 'N/A';
    } else if (aksi == 'BATALKAN') {
      // For BATALKAN, keterangan is the surah name directly, e.g., "An-Naba'"
      return keterangan.trim();
    }
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SetoranMhs>(
      future: setoranFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.blueAccent),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData ||
            snapshot.data!.response != true ||
            snapshot.data!.data == null ||
            snapshot.data!.data!.setoran == null ||
            snapshot.data!.data!.setoran!.log == null ||
            snapshot.data!.data!.setoran!.log!.isEmpty) {
          return const Center(child: Text('Tidak ada data riwayat tersedia'));
        }

        final logs = snapshot.data!.data!.setoran!.log!;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Setoran',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4A4A4A),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    final isValidasi = log.aksi == 'VALIDASI';
                    final isBatalkan = log.aksi == 'BATALKAN';
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          left: BorderSide(
                            color:
                                isValidasi
                                    ? const Color(0xFF4CAF50)
                                    : const Color(0xFFF44336),
                            width: 3,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          isBatalkan
                              ? 'PEMBATALAN'
                              : isValidasi
                              ? 'VALIDASI'
                              : 'LAINNYA',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4A4A4A),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Surah: ${_extractSurah(log.keterangan, log.aksi)}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF888888),
                              ),
                            ),
                            Text(
                              'Tanggal: ${_formatDate(log.timestamp)}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
