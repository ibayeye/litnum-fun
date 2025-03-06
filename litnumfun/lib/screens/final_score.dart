import 'package:flutter/material.dart';

class FinalScore extends StatefulWidget {
  const FinalScore({super.key});

  @override
  State<FinalScore> createState() => _FinalScoreState();
}

class _FinalScoreState extends State<FinalScore> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(color: Color(0xFF604CC3)),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.1, vertical: screenheight * 0.3),
        width: double.infinity,
        height: screenheight * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'Final Score',
                style: TextStyle(fontSize: 22),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Name :'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('totally correct :'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('totally wrong :'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'TOTAL SCORE',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10, horizontal: screenWidth * 0.2),
              child: Text(
                '100',
                style: TextStyle(
                  fontSize: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
