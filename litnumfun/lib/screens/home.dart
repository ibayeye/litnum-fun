import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:litnumfun/screens/literasi_qoestion1.dart';

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
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF604CC3),
        child: Column(
          children: [
            SizedBox(
              height: screenheight * 0.1,
            ),
            Text(
              'Hallo! ${widget.name}',
              style: const TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: screenheight * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(top: screenheight * 0.01),
              child: SvgPicture.asset(
                'assets/images/litnum.svg',
                fit: BoxFit.cover,
                height: 80,
              ),
            ),
            SizedBox(
              height: screenheight * 0.03,
            ),
            const Text(
              "Pilih salah satu game:",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(
              height: screenheight * 0.02,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LiterasiQoestion1()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFFFFA725),
                    minimumSize: Size(screenWidth * 0.5, screenheight * 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Literasi',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            ),
            SizedBox(
              height: screenheight * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(screenWidth * 0.5, screenheight * 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:const Text(
                    'Numerasi',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
