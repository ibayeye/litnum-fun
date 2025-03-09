import 'package:flutter/material.dart';
import '../csv_service.dart';
import '../question.dart';

class QuestionScreen extends StatefulWidget {
  final String category;

  const QuestionScreen({super.key, required this.category});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final questions = await CSVService.loadQuestions(widget.category);
    setState(() {
      _questions = questions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Soal ${widget.category}")),
      body: _questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final question = _questions[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question.soal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildOption(question.optionA),
                        _buildOption(question.optionB),
                        _buildOption(question.optionC),
                        _buildOption(question.optionD),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildOption(String text) {
   final Color buttonColor = widget.category == 'Literasi' 
        ? Colors.orange // Warna oranye untuk Literasi
        : Colors.blue;  // Warna biru untuk Numerasi

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {}, // Nanti bisa diisi dengan pengecekan jawaban
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
