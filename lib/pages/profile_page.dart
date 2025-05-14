import 'package:flutter/material.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';
import 'package:hafalyuk_mhs/widgets/card_item._widget.dart';

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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFD9D9D9), width: 1),
                    ),
                    elevation: 2,
                    color: const Color(0xFFF9FAFB),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.blueAccent,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
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