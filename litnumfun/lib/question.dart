// question.dart
class Question {
  final int id;
  final String soal;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String jawaban;
  final String category;

  Question({
    required this.id,
    required this.soal,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.jawaban,
    required this.category,
  });

  // Factory constructor untuk membuat objek Question dari list CSV
 factory Question.fromList(List<String> data) {
  return Question(
    id: 0, // Karena tidak ada kolom ID di CSV, kita pakai default 0
    soal: data[0],  // Kolom pertama adalah soal
    optionA: data[1], 
    optionB: data[2], 
    optionC: data[3], 
    optionD: data[4], 
    jawaban: data[5], 
    category: 'determined_later',
  );
}

  @override
  String toString() {
    return 'Question{id: $id, soal: $soal, jawaban: $jawaban}';
  }
}