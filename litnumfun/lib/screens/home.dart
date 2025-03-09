import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'question_screen.dart';

class Home extends StatefulWidget {
  final String name;

  const Home({super.key, required this.name});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF604CC3),
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.1),
            Text('Hallo! ${widget.name}', style: const TextStyle(color: Colors.white, fontSize: 20)),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.01),
              child: SvgPicture.asset(
                'assets/images/litnum.svg',
                fit: BoxFit.cover,
                height: 80,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            const Text("Pilih salah satu game:", style: TextStyle(color: Colors.white, fontSize: 16)),
            SizedBox(height: screenHeight * 0.02),
            _buildCategoryButton(context, "Literasi", Colors.orange),
            SizedBox(height: screenHeight * 0.05),
            _buildCategoryButton(context, "Numerasi", Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionScreen(category: category)),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.5, MediaQuery.of(context).size.height * 0.08),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(category, style: const TextStyle(color: Colors.white, fontSize: 24)),
      ),
    );
  }
}
