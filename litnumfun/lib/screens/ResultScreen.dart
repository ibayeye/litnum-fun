import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  final String userName;
  const ResultScreen({super.key, required this.userName});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
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
        'http://192.168.202.239:5000/api/v1/userResult/${widget.userName}');
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

  Widget buildInfoCard(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                          buildInfoCard(Icons.menu_book, 'Benar Literasi',
                              '${userData!['correctLit']}'),
                          buildInfoCard(Icons.menu_book_outlined,
                              'Salah Literasi', '${userData!['wrongLit']}'),
                          buildInfoCard(Icons.calculate, 'Benar Numerasi',
                              '${userData!['correctNum']}'),
                          buildInfoCard(Icons.calculate_outlined,
                              'Salah Numerasi', '${userData!['wrongNum']}'),
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
