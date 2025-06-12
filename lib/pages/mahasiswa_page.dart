import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/pages/dashboard_page.dart';
import 'package:hafalyuk_mhs/pages/history_page.dart';
import 'package:hafalyuk_mhs/pages/login_page.dart';
import 'package:hafalyuk_mhs/pages/profile_page.dart';
import 'package:hafalyuk_mhs/services/auth_service.dart';
import 'package:hafalyuk_mhs/services/hafalan_service.dart';
import 'package:hafalyuk_mhs/widgets/logout_alert.dart';

class MahasiswaPage extends StatefulWidget {
  const MahasiswaPage({super.key});

  @override
  _MahasiswaPageState createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage>
    with SingleTickerProviderStateMixin {
  late final AuthService authService;
  late final SetoranService setoranService;
  late final Future<SetoranMhs> _setoranFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    setoranService = SetoranService(authService);
    _setoranFuture = setoranService.getSetoranData();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        items: const [
          Icon(Icons.dashboard_rounded),
          Icon(Icons.history),
          Icon(Icons.person),
        ],
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
              String initials = name.isNotEmpty
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
                  backgroundColor: const Color(0xFF4A4A4A),
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
                showLogoutDialog(
                  context,
                  authService,
                );
              },
              child: const Icon(Icons.logout_rounded),
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          _tabController.index == 0
              ? 'Dashboard'
              : _tabController.index == 1
                  ? 'Riwayat'
                  : 'Profile',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A4A4A),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          color: Color(0xFFFFF8E7),
        ),
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            DashboardPage(
              setoranFuture: _setoranFuture,
              authService: authService,
              setoranService: setoranService,
            ),
            HistoryPage(setoranFuture: _setoranFuture),
            ProfilePage(setoranFuture: _setoranFuture),
          ],
        ),
      ),
    );
  }
}