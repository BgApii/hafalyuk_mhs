import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting text with static "Hi, " and shimmer for placeholder
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Hi, ',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF4A4A4A),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(width: 250, height: 20, color: Colors.white),
                ),
              ],
            ),
            // Other greeting text shimmer
            const SizedBox(height: 5.0),
            Text(
              'Semangat Setorannya...',
              style: GoogleFonts.poppins(
                color: Color(0xFF888888),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Divider(color: Color(0xFFEAEAEA), thickness: 4, endIndent: 140),
            const SizedBox(height: 5),
            Text(
              'Progres Muroja’ah Kamu...',
              style: GoogleFonts.poppins(
                color: Color(0xFF4A4A4A),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(color: Color(0xFF888888), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CircularPercentIndicator(
                        radius: 75,
                        lineWidth: 18.0,
                        percent: 0 / 100,
                        center: Container(
                          color: Colors.white,
                          width: 60,
                          height: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 18),
                Expanded(
                  child: Column(
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
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                          width: 20,
                          height: 20,
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
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                          width: 20,
                          height: 20,
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
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Persyaratan Akademik',
              style: GoogleFonts.poppins(
                color: Color(0xFF4A4A4A),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Berikut Progres dari Muroja’ah untuk persyaratan akademik di UIN SUSKA RIAU...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color(0xFF888888),
              ),
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                height: 275,
                viewportFraction: 0.6,
                enlargeCenterPage: true,
                enlargeFactor: 0.27,
              ),
              items: List.generate(
                3,
                (index) => Container(
                  width: 180,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    border: Border.all(color: Color(0xFF888888), width: 2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 55,
                                height: 17,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CircularPercentIndicator(
                            radius: 65,
                            animation: false,
                            animationDuration: 1200,
                            lineWidth: 18.0,
                            percent: 0 / 100,
                            center: Container(
                              color: Colors.white,
                              width: 60,
                              height: 30,
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 80,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Carousel dots shimmer
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
