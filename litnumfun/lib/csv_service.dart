import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'question.dart';

class CSVService {
  static Future<List<Question>> loadQuestions(String category) async {
    String filePath = category == 'Literasi'
        ? 'assets/soal_literasi_fixed.csv'
        : 'assets/soal_numerasi_fixed.csv';

    final rawData = await rootBundle.loadString(filePath);

    // Mengubah pemisah kolom menjadi titik koma (;)
    List<List<dynamic>> csvTable = const CsvToListConverter(
      eol: '\n',            // Pemisah baris
      fieldDelimiter: ';',  // Ganti menjadi titik koma sesuai format file CSV
      textDelimiter: '"',   // Pembatas teks
      shouldParseNumbers: false, // Penting: Jaga semua data tetap string
    ).convert(rawData);

    List<Question> questions = [];

    for (int i = 1; i < csvTable.length; i++) {
      // Skip header
      List<dynamic> row = csvTable[i];

      print("Baris ke-$i: $row"); // Debugging, lihat isi setiap baris

      if (row.length >= 6) {
        questions.add(Question.fromList(row.map((e) => e.toString()).toList()));
      } else {
        print("❌ ERROR: Baris kurang dari 6 kolom -> $row");
      }
    }

    return questions;
  }
}