import 'package:flutter/material.dart';
import 'package:hafalyuk_mhs/models/hafalan_model.dart';

class DetailSetoranPage extends StatelessWidget {
  final Setoran? setoran;

  const DetailSetoranPage({super.key, this.setoran});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Setoran'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: setoran == null || setoran?.detail == null || setoran!.detail!.isEmpty
            ? const Center(child: Text('Belum ada detail setoran.'))
            : ListView.builder(
                itemCount: setoran?.detail!.length,
                itemBuilder: (context, index) {
                  final detail = setoran?.detail![index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      title: Text('${detail?.nama ?? "N/A"} - ${detail?.label ?? "N/A"}'),
                      subtitle: Text('Sudah Setor: ${detail?.sudahSetor == true ? "Ya" : "Belum"}'),
                    ),
                  );
                },
              ),
      ),
    );
  }
}