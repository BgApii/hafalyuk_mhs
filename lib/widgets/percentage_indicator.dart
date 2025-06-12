import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/pages/detail_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PercentageIndicator extends StatelessWidget {
  const PercentageIndicator({
    super.key,
    required this.setoranData,
    required this.index,
    required this.title,
    required Future<SetoranMhs> setoranFuture,
  }) : _setoranFuture = setoranFuture;

  final Data setoranData;
  final int index;
  final String title;
  final Future<SetoranMhs> _setoranFuture;

  String formatPercentage(double? value) {
    if (value == null) return '0%';
    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    } else {
      return '${value.toStringAsFixed(1)}%';
    }
  }

  @override
  Widget build(context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        border: Border.all(color: Color(0xFF888888), width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                final setoranMhs = await _setoranFuture;
                if (setoranMhs.response == true && setoranMhs.data != null) {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder:
                          (
                            context,
                            animation,
                            secondaryAnimation,
                          ) => DetailPage(
                            setoran: setoranMhs.data!.setoran,
                            filterLabel: title,
                          ),
                      transitionsBuilder: (
                        context,
                        animation,
                        secondaryAnimation,
                        child,
                      ) {
                        const begin = Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;

                        var tween = Tween(
                          begin: begin,
                          end: end,
                        ).chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 500),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Gagal memuat detail setoran.'),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Detail',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Color(0xFF21ABA5),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: Color(0xFF21ABA5),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            CircularPercentIndicator(
              radius: 65,
              animation: false,
              animationDuration: 1200,
              lineWidth: 18.0,
              percent:
                  (setoranData.setoran?.ringkasan?[index].persentaseProgresSetor
                          ?.toDouble() ??
                      0.0) /
                  100,
              center: Text(
                formatPercentage(
                  setoranData.setoran?.ringkasan?[index].persentaseProgresSetor,
                ),
                style: GoogleFonts.poppins(fontSize: 25),
              ),
              progressColor: Color(0xFFC2E9D7),
              backgroundColor: Color(0xFFD9D9D9),
            ),
            SizedBox(height: 8),
            Text(
              title.replaceAll('_', ' '),
              style: GoogleFonts.poppins(
                color: Color(0xFF4A4A4A),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}