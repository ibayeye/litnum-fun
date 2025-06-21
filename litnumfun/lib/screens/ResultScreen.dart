import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  final String userName;
  const ResultScreen({super.key, required this.userName});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

String formatDuration(int seconds) {
  final int minutes = seconds ~/ 60;
  final int remainingSeconds = seconds % 60;
  return "$minutes menit $remainingSeconds detik";
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserResult();
  }

  Future<void> fetchUserResult() async {
    final url = Uri.parse(
        'https://litnum-backend.vercel.app/api/v1/userResult/${widget.userName}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          userData = json.decode(response.body);
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          errorMessage = 'User tidak ditemukan.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Terjadi kesalahan server.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal menghubungi server.';
        isLoading = false;
      });
    }
  }

  Widget buildInfoCard(IconData icon, String title, String value,
      {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
        trailing: onTap != null
            ? const Icon(Icons.arrow_forward_ios, size: 16)
            : null,
        onTap: onTap,
      ),
    );
  }

  void showDetailDialog(String title, List<dynamic> items, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: items.isEmpty
                ? const Center(child: Text('Tidak ada data'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                type == 'correct' ? Colors.green : Colors.red,
                            child: Text(
                              '${item['questionNumber'] ?? index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            item['question'] ?? 'Soal ${index + 1}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Jawaban: ${item['userAnswer'] ?? '-'}'),
                              if (type == 'wrong')
                                Text(
                                  'Jawaban Benar: ${item['correctAnswer'] ?? '-'}',
                                  style: const TextStyle(color: Colors.green),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hitung total durasi di sini
    final int durationLit = userData?['durationLitInSeconds'] ?? 0;
    final int durationNum = userData?['durationNumInSeconds'] ?? 0;
    final int totalDuration = durationLit + durationNum;

    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Akhir')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : errorMessage.isNotEmpty
                ? Text(
                    errorMessage,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Nama: ${userData!['name']}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                          const SizedBox(height: 20),
                          buildInfoCard(
                            Icons.menu_book,
                            'Benar Literasi',
                            '${userData!['correctLit']}',
                            onTap: () => showDetailDialog(
                                'Soal Literasi yang Benar',
                                userData!['correctLitQuestions'] ?? [],
                                'correct'),
                          ),
                          buildInfoCard(
                            Icons.menu_book_outlined,
                            'Salah Literasi',
                            '${userData!['wrongLit']}',
                            onTap: () => showDetailDialog(
                                'Soal Literasi yang Salah',
                                userData!['wrongLitQuestions'] ?? [],
                                'wrong'),
                          ),
                          buildInfoCard(
                            Icons.calculate,
                            'Benar Numerasi',
                            '${userData!['correctNum']}',
                            onTap: () => showDetailDialog(
                                'Soal Numerasi yang Benar',
                                userData!['correctNumQuestions'] ?? [],
                                'correct'),
                          ),
                          buildInfoCard(
                            Icons.calculate_outlined,
                            'Salah Numerasi',
                            '${userData!['wrongNum']}',
                            onTap: () => showDetailDialog(
                                'Soal Numerasi yang Salah',
                                userData!['wrongNumQuestions'] ?? [],
                                'wrong'),
                          ),
                          // Cards durasi yang sudah diperbaiki
                          buildInfoCard(
                            Icons.timer,
                            'Waktu Menyelesaikan Soal',
                            formatDuration(totalDuration),
                          ),
                          // buildInfoCard(
                          //   Icons.timer_sharp,
                          //   'Waktu Menyelesaikan Literasi',
                          //   formatDuration(durationLit),
                          // ),
                          // buildInfoCard(
                          //   Icons.timer,
                          //   'Waktu Menyelesaikan Numerasi',
                          //   formatDuration(durationNum),
                          // ),
                          buildInfoCard(Icons.grade, 'Skor Literasi',
                              '${userData!['litResult']}%'),
                          buildInfoCard(Icons.grade_outlined, 'Skor Numerasi',
                              '${userData!['numResult']}%'),
                          const SizedBox(height: 20),
                          Card(
                            color: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Text(
                                    'Total Skor',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${userData!['allResult'].toStringAsFixed(2)}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
