import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetailPage extends StatelessWidget {
  final Setoran? setoran;
  final String filterLabel;

  const DetailPage({super.key, this.setoran, required this.filterLabel});

  @override
  Widget build(BuildContext context) {
    final filteredDetails =
        (setoran?.detail ?? [])
            .where((detail) => detail.label == filterLabel)
            .toList();

    final ringkasanEntry = (setoran?.ringkasan ?? []).firstWhere(
      (ringkasan) => ringkasan.label == filterLabel,
      orElse:
          () => Ringkasan(
            label: filterLabel,
            totalWajibSetor: 0,
            totalSudahSetor: 0,
            totalBelumSetor: 0,
            persentaseProgresSetor: 0,
          ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          filterLabel,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A4A4A),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          color: Color(0xFFFFF8E7),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      border: Border.all(color: Color(0xFF888888), width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(14.0),
                    child: CircularPercentIndicator(
                      radius: 75,
                      animation: true,
                      animationDuration: 1200,
                      lineWidth: 18.0,
                      percent:
                          (ringkasanEntry.persentaseProgresSetor ?? 0.0) / 100,
                      center: Text(
                        '${ringkasanEntry.persentaseProgresSetor?.toInt() ?? 0}%',
                        style: GoogleFonts.poppins(fontSize: 25),
                      ),
                      progressColor: Color(0xFFC2E9D7),
                      backgroundColor: Color(0xFFD9D9D9),
                    ),
                  ),
                  SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Total Wajib Setor:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                            Text(
                              '${ringkasanEntry.totalWajibSetor ?? 0}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF888888),
                              ),
                            ),
                            Divider(
                              color: Color(0xFFC2E9D7),
                              thickness: 4,
                              height: 20,
                            ),
                            Text(
                              'Total Sudah Setor:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                            Text(
                              '${ringkasanEntry.totalSudahSetor ?? 0}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF888888),
                              ),
                            ),
                            Divider(
                              color: Color(0xFFC2E9D7),
                              thickness: 4,
                              height: 20,
                            ),
                            Text(
                              'Total Belum Setor:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                            Text(
                              '${ringkasanEntry.totalBelumSetor ?? 0}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Color(0xFF888888),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Daftar Surah',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child:
                    filteredDetails.isEmpty
                        ? Center(
                          child: Text(
                            'Belum ada detail setoran untuk $filterLabel.',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        )
                        : Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFFFFFFF),
                            border: Border.all(
                              color: Color(0xFF888888),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView.builder(
                            itemCount: filteredDetails.length,
                            itemBuilder: (context, index) {
                              final detail = filteredDetails[index];
                              return ListTile(
                                title: Text(
                                  detail.nama ?? "N/A",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                subtitle: Text(
                                  'Sudah Setor: ${detail.sudahSetor == true ? "Ya" : "Belum"}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
