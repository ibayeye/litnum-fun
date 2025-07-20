import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:litnumfun/api_services.dart';
import 'package:litnumfun/screens/home.dart';
import 'package:litnumfun/screens/homeUser.dart';
import 'package:litnumfun/screens/login_admin.dart';

class Sigin extends StatefulWidget {
  const Sigin({super.key});

  @override
  State<Sigin> createState() => _SiginState();
}

class _SiginState extends State<Sigin> {
  final TextEditingController _controller = TextEditingController();
  final ApiService apiService = ApiService(
      baseUrl:
          'https://backup-litnumfun.vercel.app/api/v1'); // Ganti dengan URL backend kamu
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleSubmit() async {
    final name = _controller.text.trim();

    if (name.isEmpty) {
      setState(() {
        _errorMessage = "Nama tidak boleh kosong!";
      });
      print(
          "Error: $_errorMessage"); // Debugging untuk memastikan error message diubah
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await apiService.request(
      endpoint: '/playUser',
      method: 'POST',
      body: {'name': name},
    );

    setState(() {
      _isLoading = false;
    });

    if (response.containsKey('error')) {
      setState(() {
        _errorMessage = response['error'];
      });
    } else {
      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => HomeUser(name: name)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/siginbg-new.svg',
              fit: BoxFit.cover,
            ),
            // const Text(
            //   'SDN 013 PASIR KALIKI BANDUNG',
            //   style: TextStyle(
            //       color: Color(0xFF604CC3),
            //       fontSize: 22,
            //       fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: screenHeight * 0.1),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Masukkan Nama Kamu',
                  errorText: _errorMessage, // Menampilkan error jika ada
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.05),
                  backgroundColor: Color(0xFF604CC3),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Ayo Mulai',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginAdmin()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.9, screenHeight * 0.05),
                  backgroundColor: Colors.orangeAccent,
                ),
                child: const Text(
                  'Login Sebagai Admin',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
