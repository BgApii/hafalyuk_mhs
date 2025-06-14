import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/widgets/detail_bottom_sheet.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class DetailPage extends StatelessWidget {
  final Setoran? setoran;
  final String filterLabel;
  String formatPercentage(double? value) {
    if (value == null) return '0%';
    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    } else {
      return '${value.toStringAsFixed(1)}%';
    }
  }

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

    return Container(
      color: const Color(0xFFFFF8E7),
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              filterLabel.replaceAll('_', ' '),
              style: GoogleFonts.poppins(
                fontSize: 20,
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
                          border: Border.all(
                            color: Color(0xFF888888),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(14.0),
                        child: CircularPercentIndicator(
                          radius: 75,
                          animation: true,
                          animationDuration: 1200,
                          lineWidth: 18.0,
                          percent:
                              (ringkasanEntry.persentaseProgresSetor ?? 0.0) /
                              100,
                          center: Text(
                            formatPercentage(
                              ringkasanEntry.persentaseProgresSetor,
                            ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFFFFFF),
                        border: Border.all(color: Color(0xFF888888), width: 2),
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
                            subtitle: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      detail.sudahSetor == true
                                          ? Color(0xFFC2E9D7)
                                          : Color.fromARGB(255, 255, 200, 200),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    detail.sudahSetor == true
                                        ? "Sudah"
                                        : "Belum",
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              onPressed:
                                  () => showModalBottomSheet(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25),
                                      ),
                                    ),
                                    builder:
                                        (context) =>
                                            DetailBottomSheet(detail: detail),
                                  ),
                              icon: Icon(Icons.description_rounded),
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
        ),
      ),
    );
  }
}
