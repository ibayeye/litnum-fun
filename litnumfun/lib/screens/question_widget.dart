import 'package:flutter/material.dart';
import '../question.dart';

class QuestionWidget extends StatelessWidget {
  final Question question;
  final Function(String) onAnswerSelected;
  final String category; // Tambahkan parameter kategori

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.onAnswerSelected,
    required this.category, // Terima parameter kategori
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tampilkan soal dengan widget Text biasa
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            question.soal,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // Pilihan jawaban
        _buildOptionButton(question.optionA, 'A'),
        _buildOptionButton(question.optionB, 'B'),
        _buildOptionButton(question.optionC, 'C'),
        _buildOptionButton(question.optionD, 'D'),
      ],
    );
  }

  Widget _buildOptionButton(String optionText, String optionKey) {
    // Tentukan warna berdasarkan kategori
    final Color buttonColor = category == 'Literasi' 
        ? Colors.orange // Warna oranye untuk Literasi
        : Colors.blue;  // Warna biru untuk Numerasi
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: OutlinedButton(
        onPressed: () => onAnswerSelected(optionKey),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(60),
          alignment: Alignment.centerLeft,
          // Gunakan warna sesuai kategori
          side: BorderSide(color: buttonColor),
          foregroundColor: buttonColor, // Warna teks
        ),
        child: Text(
          "$optionKey. $optionText",
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}