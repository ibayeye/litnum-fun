class Question {
  final String soal;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String jawaban;

  Question({
    required this.soal,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.jawaban,
  });

  factory Question.fromList(List<String> row) {
    return Question(
      soal: row[0],
      optionA: row[1],
      optionB: row[2],
      optionC: row[3],
      optionD: row[4],
      jawaban: row[5],
    );
  }
}