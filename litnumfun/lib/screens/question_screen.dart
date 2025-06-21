import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:litnumfun/api_services.dart';
import 'dart:convert';
import '../csv_service.dart';
import '../question.dart';

class QuestionScreen extends StatefulWidget {
  final String category;
  final String userName;

  const QuestionScreen({
    super.key,
    required this.category,
    required this.userName,
  });

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  List<Question> _questions = [];
  Map<int, String> _userAnswers = {};
  bool _quizCompleted = false;
  bool _isSubmitting = false;
  bool _isLoading = true;
  int _currentQuestionIndex = 0;

  int _correctLit = 0;
  int _wrongLit = 0;
  int _correctNum = 0;
  int _wrongNum = 0;

  late DateTime _startTime;
  late DateTime _endTime;
  Duration _totalDuration = Duration.zero;

  // List untuk menyimpan detail jawaban
  List<Map<String, dynamic>> _litAnswerDetails = [];
  List<Map<String, dynamic>> _numAnswerDetails = [];

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await CSVService.loadQuestions(widget.category);

      // Tetapkan kategori untuk setiap pertanyaan
      for (var i = 0; i < questions.length; i++) {
        questions[i] = Question(
          id: i + 1, // Tetapkan ID unik
          soal: questions[i].soal,
          optionA: questions[i].optionA,
          optionB: questions[i].optionB,
          optionC: questions[i].optionC,
          optionD: questions[i].optionD,
          jawaban: questions[i].jawaban.trim(), // Bersihkan spasi di sini
          category:
              widget.category, // Pastikan ini persis sama dengan yang dicek
        );
      }

      // Debug setelah soal dimuat
      for (var q in questions) {
        print(
            'Loaded Question ${q.id}: Category=${q.category}, Answer=${q.jawaban}');
      }

      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading questions: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error memuat soal: ${e.toString()}')),
      );
    }
  }

  // Mengecek apakah jawaban benar
  bool _isAnswerCorrect(Question question, String answer) {
    // Membersihkan format jawaban dari spasi atau karakter tambahan
    String correctAnswer = question.jawaban.trim();
    if (correctAnswer.endsWith(")")) {
      correctAnswer = correctAnswer.substring(0, correctAnswer.length - 1);
    }

    print(
        "Mengecek jawaban: ${question.id}, User: $answer, Benar: $correctAnswer (setelah dibersihkan)");
    return answer == correctAnswer;
  }

  // Mengecek semua jawaban dan menghitung skor
  void _checkAnswers() {
    _correctLit = 0;
    _wrongLit = 0;
    _correctNum = 0;
    _wrongNum = 0;

    // Clear previous answer details
    _litAnswerDetails.clear();
    _numAnswerDetails.clear();

    for (var i = 0; i < _questions.length; i++) {
      final question = _questions[i];
      final userAnswer = _userAnswers[question.id];

      // Periksa apakah userAnswer tidak null dan tidak kosong
      if (userAnswer != null && userAnswer.isNotEmpty) {
        final bool isCorrect = _isAnswerCorrect(question, userAnswer);

        // Buat detail jawaban
        Map<String, dynamic> answerDetail = {
          "questionId": "q_${question.id}",
          "questionNumber": question.id,
          "question": question.soal,
          "userAnswer": userAnswer,
          "correctAnswer": question.jawaban.trim(),
          "isCorrect": isCorrect
        };

        // Debug untuk melihat apakah logika kategori bekerja
        print(
            'Question ${question.id}, Category: ${question.category}, isCorrect: $isCorrect');

        if (question.category.toLowerCase() == 'numerasi') {
          _numAnswerDetails.add(answerDetail);
          if (isCorrect) {
            _correctNum++;
            print('Increment correctNum to $_correctNum');
          } else {
            _wrongNum++;
          }
        } else if (question.category.toLowerCase() == 'literasi') {
          _litAnswerDetails.add(answerDetail);
          if (isCorrect) {
            _correctLit++;
            print('Increment correctLit to $_correctLit');
          } else {
            _wrongLit++;
          }
        }
      } else {
        // Jika tidak dijawab, dianggap salah
        Map<String, dynamic> answerDetail = {
          "questionId": "q_${question.id}",
          "questionNumber": question.id,
          "question": question.soal,
          "userAnswer": "Tidak dijawab",
          "correctAnswer": question.jawaban.trim(),
          "isCorrect": false
        };

        if (question.category.toLowerCase() == 'numerasi') {
          _numAnswerDetails.add(answerDetail);
          _wrongNum++;
        } else {
          _litAnswerDetails.add(answerDetail);
          _wrongLit++;
        }
      }
    }

    print('Final Counts - Category: ${widget.category}');
    print('Correct Literasi: $_correctLit');
    print('Wrong Literasi: $_wrongLit');
    print('Correct Numerasi: $_correctNum');
    print('Wrong Numerasi: $_wrongNum');

    _submitResults();
  }

  // Mengirim hasil ke database
  Future<void> _submitResults() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      _endTime = DateTime.now();
      _totalDuration = _endTime.difference(_startTime);
      
      // 1. Kirim hasil skor terlebih dahulu (API yang sudah ada)
      await _submitScoreResults();

      // 2. Kirim detail jawaban
      await _submitAnswerDetails();


      setState(() {
        _quizCompleted = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim data: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // Fungsi untuk mengirim skor (API yang sudah ada)
  Future<void> _submitScoreResults() async {
    // Buat data dasar yang selalu dikirim
    final Map<String, dynamic> resultData = {
      'name': widget.userName,
    };

    // Tambahkan data berdasarkan kategori yang sedang dikerjakan
    if (widget.category == 'Literasi') {
      resultData['correctLit'] = _correctLit;
      resultData['wrongLit'] = _wrongLit;
      resultData['litResult'] =
          _correctLit > 0 ? (_correctLit / (_correctLit + _wrongLit)) * 100 : 0;
      resultData['durationLitInSeconds'] = _totalDuration.inSeconds;
    } else if (widget.category == 'Numerasi') {
      resultData['correctNum'] = _correctNum;
      resultData['wrongNum'] = _wrongNum;
      resultData['numResult'] =
          _correctNum > 0 ? (_correctNum / (_correctNum + _wrongNum)) * 100 : 0;
      resultData['durationNumInSeconds'] = _totalDuration.inSeconds;
    }

    // Kirim ke server
    final response = await http.post(
      Uri.parse('https://litnum-backend.vercel.app/api/v1/playUser'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(resultData),
    );

    // Logging untuk debugging
    print('Score Response status: ${response.statusCode}');
    print('Score Response body: ${response.body}');

    // Ubah pengecekan respons untuk menerima status 200 & 201
    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Gagal menyimpan skor. Kode: ${response.statusCode}");
    }
  }

  // Fungsi untuk mengirim detail jawaban (API baru)
  Future<void> _submitAnswerDetails() async {
    final Map<String, dynamic> answerData = {
      'name': widget.userName,
    };

    // Tambahkan detail jawaban berdasarkan kategori
    if (widget.category == 'Literasi') {
      answerData['litQuestions'] = _litAnswerDetails;
      answerData['numQuestions'] = []; // Kosong untuk literasi
    } else if (widget.category == 'Numerasi') {
      answerData['litQuestions'] = []; // Kosong untuk numerasi
      answerData['numQuestions'] = _numAnswerDetails;
    }

    // Kirim detail jawaban ke API baru
    final response = await http.post(
      Uri.parse('https://litnum-backend.vercel.app/api/v1/saveAnswers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(answerData),
    );

    print('Answer Details Response status: ${response.statusCode}');
    print('Answer Details Response body: ${response.body}');

    if (response.statusCode != 200) {
      print(
          'Warning: Gagal menyimpan detail jawaban. Kode: ${response.statusCode}');
      // Tidak throw error karena ini optional, skor sudah tersimpan
    }
  }

  // Memilih jawaban
  void _selectAnswer(int questionId, String selectedOption) {
    setState(() {
      _userAnswers[questionId] = selectedOption;
      print('Jawaban disimpan untuk soal $questionId: $selectedOption');
    });
  }

  // Berpindah ke soal berikutnya
  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Ini soal terakhir
      setState(() {}); // pastikan update
      Future.delayed(const Duration(milliseconds: 100), () {
        _checkAnswers();
      });
    }
  }

  // Berpindah ke soal sebelumnya
  void _prevQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  // Menampilkan hasil quiz
  Widget _buildResultScreen() {
    final int totalQuestions = _questions.length;
    final int correctAnswers =
        widget.category == 'Literasi' ? _correctLit : _correctNum;
    final double percentage =
        totalQuestions > 0 ? (correctAnswers / totalQuestions) * 100 : 0;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              color: Colors.amber,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(
              "Hasil Quiz ${widget.category}",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    "Jawaban Benar",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$correctAnswers dari $totalQuestions",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Persentase",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${percentage.toStringAsFixed(1)}%",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: percentage >= 75 ? Colors.green : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              label: const Text(
                "Kembali ke Menu",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text("Soal ${widget.category}")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Soal ${widget.category}")),
        body: const Center(
          child: Text("Tidak ada soal tersedia. Silakan coba lagi nanti."),
        ),
      );
    }

    if (_isSubmitting) {
      return Scaffold(
        appBar: AppBar(title: Text("Soal ${widget.category}")),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text("Menyimpan hasil..."),
              SizedBox(height: 10),
              Text("Mohon tunggu sebentar",
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    if (_quizCompleted) {
      return Scaffold(
        appBar: AppBar(title: Text("Hasil ${widget.category}")),
        body: _buildResultScreen(),
      );
    }

    // Tampilkan soal satu per satu
    final question = _questions[_currentQuestionIndex];
    final userAnswer = _userAnswers[question.id];

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Soal ${widget.category} (${_currentQuestionIndex + 1}/${_questions.length})"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Nomor soal dan soal
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Soal ${_currentQuestionIndex + 1}:",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      question.soal,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Opsi jawaban
            _buildAnswerOption(question.id, "A", question.optionA),
            _buildAnswerOption(question.id, "B", question.optionB),
            _buildAnswerOption(question.id, "C", question.optionC),
            _buildAnswerOption(question.id, "D", question.optionD),

            // Indikator jawaban
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "${_userAnswers.length}/${_questions.length} soal dijawab",
                style: TextStyle(
                  color: _userAnswers.length == _questions.length
                      ? Colors.green
                      : Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Navigasi soal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentQuestionIndex > 0 ? _prevQuestion : null,
                  child: const Text("Sebelumnya"),
                ),
                ElevatedButton(
                  onPressed: _userAnswers[question.id] != null
                      ? () {
                          setState(() {}); // Update jawaban terbaru

                          if (_currentQuestionIndex == _questions.length - 1) {
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              _checkAnswers();
                            });
                          } else {
                            _nextQuestion();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _currentQuestionIndex == _questions.length - 1
                            ? Colors.green
                            : null,
                  ),
                  child: Text(_currentQuestionIndex == _questions.length - 1
                      ? "Selesai"
                      : "Selanjutnya"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOption(int questionId, String option, String text) {
    final Color buttonColor =
        widget.category == 'Literasi' ? Colors.orange : Colors.blue;

    final bool isSelected = _userAnswers[questionId] == option;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onPressed: () {
          _selectAnswer(questionId, option);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? buttonColor.withOpacity(0.8) : buttonColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isSelected
                ? BorderSide(color: Colors.white, width: 2)
                : BorderSide.none,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$option. ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
