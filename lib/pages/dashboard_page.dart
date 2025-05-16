import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/pages/detail_page.dart';
import 'package:hafalyuk_mhs/services/auth_service.dart';
import 'package:hafalyuk_mhs/services/hafalan_service.dart';
import 'package:hafalyuk_mhs/pages/login_page.dart';
import 'package:hafalyuk_mhs/pages/profile_page.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late final AuthService authService;
  late final SetoranService setoranService;
  late Future<SetoranMhs> _setoranFuture;
  late TabController _tabController;
  int _currentCarouselIndex = 0;
  String formatPercentage(double? value) {
    if (value == null) return '0%';
    if (value == value.roundToDouble()) {
      // Whole number: display without decimals
      return '${value.toInt()}%';
    } else {
      // Decimal number: display with one decimal place
      return '${value.toStringAsFixed(1)}%';
    }
  }

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    setoranService = SetoranService(authService);
    _setoranFuture = setoranService.getSetoranData();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _setoranFuture = setoranService.getSetoranData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        index: _tabController.index,
        onTap: (index) {
          _tabController.animateTo(index);
        },
        backgroundColor: const Color(0xFFFFF8E7),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: const [Icon(Icons.dashboard_rounded), Icon(Icons.person)],
      ),
      appBar: AppBar(
        leading: FutureBuilder<SetoranMhs>(
          future: _setoranFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.data!.response == true &&
                snapshot.data!.data != null) {
              final info = snapshot.data!.data!.info;
              String name = info?.nama ?? "Unknown Name";
              String initials =
                  name.isNotEmpty
                      ? name
                          .trim()
                          .split(' ')
                          .map((e) => e[0])
                          .take(2)
                          .join()
                          .toUpperCase()
                      : "U";
              return Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: CircleAvatar(
                  backgroundColor: Color(0xFF4A4A4A),
                  child: Text(
                    initials,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                child: Text(
                  "U",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () async {
                await authService.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Icon(Icons.logout_rounded),
            ),
          ),
        ],
        centerTitle: true,
        title: FutureBuilder<SetoranMhs>(
          future: _setoranFuture,
          builder: (context, snapshot) {
            return Text(
              _tabController.index == 0 ? 'Dashboard' : 'Profile',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A4A4A),
              ),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          color: Color(0xFFFFF8E7),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Hafalan Tab
            RefreshIndicator(
              color: Colors.blueAccent,
              onRefresh: _refreshData,
              child: FutureBuilder<SetoranMhs>(
                future: _setoranFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blueAccent,
                      ),
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

                  final List<Widget> carouselItems = [
                    PercentageIndicator(
                      setoranData: setoranData,
                      index: 0,
                      title: 'KP',
                      setoranFuture: _setoranFuture,
                    ),
                    PercentageIndicator(
                      setoranData: setoranData,
                      index: 1,
                      title: 'SEMKP',
                      setoranFuture: _setoranFuture,
                    ),
                    PercentageIndicator(
                      setoranData: setoranData,
                      index: 2,
                      title: 'DAFTAR_TA',
                      setoranFuture: _setoranFuture,
                    ),
                    PercentageIndicator(
                      setoranData: setoranData,
                      index: 3,
                      title: 'SEMPRO',
                      setoranFuture: _setoranFuture,
                    ),
                    PercentageIndicator(
                      setoranData: setoranData,
                      index: 4,
                      title: 'SIDANG_TA',
                      setoranFuture: _setoranFuture,
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
                              color: Color(0xFF4A4A4A),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            'Semangat Setorannya...',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF888888),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
                          Divider(
                            color: Color(0xFFEAEAEA),
                            thickness: 4,
                            endIndent: 140,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Progres Muroja’ah Kamu...',
                            style: GoogleFonts.poppins(
                              color: Color(0xFF4A4A4A),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 5),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: CircularPercentIndicator(
                                    radius: 75,
                                    animation: true,
                                    animationDuration: 1200,
                                    lineWidth: 18.0,
                                    percent:
                                        (setoranData
                                                .setoran
                                                ?.infoDasar
                                                ?.persentaseProgresSetor
                                                ?.toDouble() ??
                                            0.0) /
                                        100,
                                    center: Text(
                                      formatPercentage(
                                        setoranData
                                            .setoran
                                            ?.infoDasar
                                            ?.persentaseProgresSetor,
                                      ),
                                      style: GoogleFonts.poppins(fontSize: 25),
                                    ),
                                    progressColor: Color(0xFFC2E9D7),
                                    backgroundColor: Color(0xFFD9D9D9),
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
                                    Text(
                                      '${setoranData.setoran?.infoDasar?.totalWajibSetor ?? 0.0}',
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
                                      '${setoranData.setoran?.infoDasar?.totalSudahSetor ?? 0.0}',
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
                                      '${setoranData.setoran?.infoDasar?.totalBelumSetor ?? 0.0}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Color(0xFF888888),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
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
                          SizedBox(height: 10),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 275,
                              autoPlay: true,
                              viewportFraction: 0.6,
                              autoPlayInterval: Duration(seconds: 5),
                              autoPlayAnimationDuration: Duration(
                                milliseconds: 800,
                              ),
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
                            children:
                                carouselItems.asMap().entries.map((entry) {
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          _currentCarouselIndex == entry.key
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
            ),
            // Profile Tab
            ProfilePage(setoranFuture: _setoranFuture),
          ],
        ),
      ),
    );
  }
}

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
      // Whole number: display without decimals
      return '${value.toInt()}%';
    } else {
      // Decimal number: display with one decimal place
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
                  // Use title directly as filterLabel since it now matches JSON label format
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
                            filterLabel:
                                title, // title is already in JSON format (e.g., SIDANG_TA)
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
              title.replaceAll(
                '_',
                ' ',
              ), // Display with spaces for readability (e.g., SIDANG TA)
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
