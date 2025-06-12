import 'package:flutter/material.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/widgets/card_item_widget.dart';

class ProfilePage extends StatelessWidget {
  final Future<SetoranMhs> setoranFuture;

  const ProfilePage({super.key, required this.setoranFuture});

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
            snapshot.data!.data == null) {
          return const Center(child: Text('No data available'));
        }

        final setoranData = snapshot.data!.data!;
        final info = setoranData.info;

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, right: 24.0, left: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: const Color(0xFF4A4A4A),
                    child: Text(
                      (info?.nama?.isNotEmpty == true
                          ? info!.nama!
                              .split(' ')
                              .map((e) => e[0].toUpperCase())
                              .take(2)
                              .join()
                          : '?'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Divider(
                  color: Color(0xFFC2E9D7),
                  thickness: 4,
                  height: 20,
                  indent: 50,
                  endIndent: 50,
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(
                        color: Color(0xFFD9D9D9),
                        width: 1,
                      ),
                    ),
                    elevation: 2,
                    color: const Color(0xFFF9FAFB),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoItem(
                            icon: Icons.person,
                            label: 'Nama',
                            value: info?.nama ?? 'N/A',
                          ),
                          InfoItem(
                            icon: Icons.badge,
                            label: 'NIM',
                            value: info?.nim ?? 'N/A',
                          ),
                          InfoItem(
                            icon: Icons.email,
                            label: 'Email',
                            value: info?.email ?? 'N/A',
                          ),
                          InfoItem(
                            icon: Icons.calendar_today,
                            label: 'Semester',
                            value: info?.semester.toString() ?? 'N/A',
                          ),
                          InfoItem(
                            icon: Icons.school,
                            label: 'Angkatan',
                            value: info?.angkatan ?? 'N/A',
                          ),
                          InfoItem(
                            icon: Icons.supervisor_account,
                            label: 'Dosen PA',
                            value: info?.dosenPa?.nama ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}