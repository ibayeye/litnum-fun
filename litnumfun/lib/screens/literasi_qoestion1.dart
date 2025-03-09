import 'package:flutter/material.dart';
import 'package:litnumfun/screens/final_score.dart';

class LiterasiQoestion1 extends StatefulWidget {
  const LiterasiQoestion1({super.key});

  @override
  State<LiterasiQoestion1> createState() => _LiterasiQoestion1State();
}

class _LiterasiQoestion1State extends State<LiterasiQoestion1> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C5DB6), Color(0xFF916E39)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
              child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenheight * 0.1, left: screenWidth * 0.02),
                child: const Align(
                  alignment: Alignment.centerLeft, // Mengatur teks ke kiri
                  child: Text(
                    'Qoestion \n\nNo.1',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.black), // Menjaga teks tetap kiri
                  ),
                ),
              ),
              SizedBox(
                height: screenheight * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: double.infinity,
                  height: screenheight * 0.2,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15)),
                  child: const Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                            'Mengapa literasi sangat penting dalam dunia pendidikan?'),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      minimumSize: Size(screenWidth * 1, screenheight * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'A. Membantu siswa dalam menyelesaikan tugas secara cepat',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
              Padding(
                padding:const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FinalScore()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purpleAccent,
                      minimumSize: Size(screenWidth * 1, screenheight * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'B. Membantu siswa dalam memahami, menganalisis, dan menerapkan informasi yang diterima',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      minimumSize: Size(screenWidth * 1, screenheight * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'C. Mempermudah siswa dalam mengikuti ujian',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(screenWidth * 1, screenheight * 0.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'D. Membuat siswa lebih cepat membaca teks panjang',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
