import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllResults();
  }

  Future<void> fetchAllResults() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.202.239:5000/api/v1/allResult'),
      );

      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          users = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }

  Color getRankColor(int index) {
    if (index == 0 || index == 1 || index == 2) {
      return Colors.green;
    } else if (index == 3 || index == 4 || index == 5) {
      return Colors.blue;
    } else {
      return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: getRankColor(index),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      user['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                        Text('Skor: ${user['allResult'].toStringAsFixed(2)}%'),
                  ),
                );
              },
            ),
    );
  }
}
