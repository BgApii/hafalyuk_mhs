import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/pages/login_page.dart';
import 'package:hafalyuk_mhs/services/auth_service.dart';
import 'package:hafalyuk_mhs/services/hafalan_service.dart';
import 'package:hafalyuk_mhs/widgets/percentage_indicator.dart';
import 'package:hafalyuk_mhs/widgets/shimmer_loading.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardPage extends StatefulWidget {
  final Future<SetoranMhs> setoranFuture;
  final AuthService authService;
  final SetoranService setoranService;

  const DashboardPage({
    super.key,
    required this.setoranFuture,
    required this.authService,
    required this.setoranService,
  });

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentCarouselIndex = 0;
  late Future<SetoranMhs> _currentSetoranFuture; // Track the current future

  @override
  void initState() {
    super.initState();
    _currentSetoranFuture = widget.setoranFuture; // Initialize with the passed future
  }

  String formatPercentage(double? value) {
    if (value == null) return '0%';
    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    } else {
      return '${value.toStringAsFixed(1)}%';
    }
  }

  Future<void> _refreshData() async {
    try {
      // Fetch new data using the SetoranService
      final newSetoranFuture = widget.setoranService.getSetoranData();
      setState(() {
        _currentSetoranFuture = newSetoranFuture; // Update the current future
      });
    } catch (e) {
      // Handle any errors during refresh
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memperbarui data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.blueAccent,
      onRefresh: _refreshData,
      child: FutureBuilder<SetoranMhs>(
        future: _currentSetoranFuture, // Use the tracked future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerLoadingWidget();
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

          final List<Widget> carouselItems = [
            PercentageIndicator(
              setoranData: setoranData,
              index: 0,
              title: 'KP',
              setoranFuture: _currentSetoranFuture, // Pass the updated future
            ),
            PercentageIndicator(
              setoranData: setoranData,
              index: 1,
              title: 'SEMKP',
              setoranFuture: _currentSetoranFuture,
            ),
            PercentageIndicator(
              setoranData: setoranData,
              index: 2,
              title: 'DAFTAR_TA',
              setoranFuture: _currentSetoranFuture,
            ),
            PercentageIndicator(
              setoranData: setoranData,
              index: 3,
              title: 'SEMPRO',
              setoranFuture: _currentSetoranFuture,
            ),
            PercentageIndicator(
              setoranData: setoranData,
              index: 4,
              title: 'SIDANG_TA',
              setoranFuture: _currentSetoranFuture,
            ),
          ];

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, ${info?.nama ?? 'N/A'}',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4A4A4A),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    'Semangat Setorannya...',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF888888),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(
                    color: Color(0xFFEAEAEA),
                    thickness: 4,
                    endIndent: 140,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Progres Muroja’ah Kamu...',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF4A4A4A),
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
                          color: const Color(0xFFFFFFFF),
                          border: Border.all(
                            color: const Color(0xFF888888),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: CircularPercentIndicator(
                            radius: 75,
                            animation: true,
                            animationDuration: 1200,
                            lineWidth: 18.0,
                            percent: (setoranData
                                        .setoran
                                        ?.infoDasar
                                        ?.persentaseProgresSetor
                                        ?.toDouble() ??
                                    0.0) /
                                100,
                            center: Text(
                              formatPercentage(
                                setoranData
                                    .setoran?.infoDasar?.persentaseProgresSetor,
                              ),
                              style: GoogleFonts.poppins(fontSize: 25),
                            ),
                            progressColor: const Color(0xFFC2E9D7),
                            backgroundColor: const Color(0xFFD9D9D9),
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Total Wajib Setor:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF4A4A4A),
                              ),
                            ),
                            Text(
                              '${setoranData.setoran?.infoDasar?.totalWajibSetor ?? 0.0}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF888888),
                              ),
                            ),
                            const Divider(
                              color: Color(0xFFC2E9D7),
                              thickness: 4,
                              height: 20,
                            ),
                            Text(
                              'Total Sudah Setor:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF4A4A4A),
                              ),
                            ),
                            Text(
                              '${setoranData.setoran?.infoDasar?.totalSudahSetor ?? 0.0}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF888888),
                              ),
                            ),
                            const Divider(
                              color: Color(0xFFC2E9D7),
                              thickness: 4,
                              height: 20,
                            ),
                            Text(
                              'Total Belum Setor:',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF4A4A4A),
                              ),
                            ),
                            Text(
                              '${setoranData.setoran?.infoDasar?.totalBelumSetor ?? 0.0}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: const Color(0xFF888888),
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
                      color: const Color(0xFF4A4A4A),
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Berikut Progres dari Muroja’ah untuk persyaratan akademik di UIN SUSKA RIAU...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 275,
                      autoPlay: true,
                      viewportFraction: 0.6,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.27,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentCarouselIndex = index;
                        });
                      },
                    ),
                    items: carouselItems,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: carouselItems.asMap().entries.map((entry) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentCarouselIndex == entry.key
                              ? const Color(0xFF4A4A4A)
                              : const Color(0xFFD9D9D9),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}