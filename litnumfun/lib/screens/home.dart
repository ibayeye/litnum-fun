import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:litnumfun/screens/literasi_qoestion1.dart';

class Home extends StatefulWidget {
  const Home({super.key});

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
        color: Color(0xFF604CC3),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: screenheight * 0.2),
              width: screenWidth * 0.3,
              height: screenheight * 0.10,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              child: SvgPicture.asset(
                'assets/images/avatar.svg',
              ),
            ),
            SizedBox(
              height: screenheight * 0.02,
            ),
            Text(
              'Esa Kurniawan Putra',
              style: TextStyle(color: Colors.white),
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
            Text(
              "select a game category:",
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
                            builder: (context) => LiterasiQoestion1()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0XFFFFA725),
                    minimumSize: Size(screenWidth * 0.5, screenheight * 0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
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
                  child: Text(
                    'Numerik',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
