import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:litnumfun/screens/home.dart';

class Sigin extends StatefulWidget {
  const Sigin({super.key});

  @override
  State<Sigin> createState() => _SiginState();
}

class _SiginState extends State<Sigin> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          width: double.infinity, // Supaya full screen
          height: double.infinity,
          child: Column(
            children: [
              SvgPicture.asset(
                'assets/images/siginbg.svg',
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: screenheight * 0.1,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: TextField(
                  decoration: InputDecoration(labelText: 'username'),
                ),
              ),
              SizedBox(
                height: screenheight * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: TextField(
                  decoration: InputDecoration(labelText: 'password'),
                ),
              ),
              SizedBox(
                height: screenheight * 0.09,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize:
                            Size(screenWidth * 0.9, screenheight * 0.05),
                        backgroundColor: Color(0xFF604CC3)),
                    child: Text(
                      'Let\'s play',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          )),
    );
  }
}
