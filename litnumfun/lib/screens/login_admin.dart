import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:litnumfun/api_services.dart';
import 'package:litnumfun/screens/home.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService =
      ApiService(baseUrl: 'https://backup-litnumfun.vercel.app/api/v1');
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleSubmit() async {
    final name = _nameController.text.trim();
    final nip = _nipController.text.trim();
    final password = _passwordController.text.trim();

    if (nip.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "NIP dan Password tidak boleh kosong!";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await apiService.request(
        endpoint: '/loginAdmin',
        method: 'POST',
        body: {'name': name, 'nip': nip, 'password': password},
      );

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('error')) {
        setState(() {
          _errorMessage = response['error'];
        });
      } else if (response.containsKey('message') &&
          response.containsKey('admin')) {
        // Login berhasil - ekstrak data dari response
        final adminData = response['admin'];
        String userRole = adminData['role'] ?? 'admin';
        String userName = adminData['name'];
        String nip = adminData['nip'].toString(); // ubah ke String
        String adminId = adminData['_id']; // ambil _id dari MongoDB misalnya

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              name: userName,
              nip: nip,
              role: userRole,
              adminId: adminId,
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = "Response tidak dikenali dari server";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = "Terjadi kesalahan: ${e.toString()}";
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nipController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
            children: [
              // SVG Image with constrained height
              Container(
                height: screenHeight * 0.45, // Batasi tinggi gambar
                width: double.infinity,
                child: SvgPicture.asset(
                  'assets/images/siginbg-new.svg',
                  fit: BoxFit.cover,
                ),
              ),

              // Form section
              Padding(
                padding: const EdgeInsets.all(18),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person_outline),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: TextField(
                  controller: _nipController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Masukkan NIP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.badge_outlined),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(18),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Masukkan Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ),

              // Error message display
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline,
                            color: Colors.red[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Login button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.9, screenHeight * 0.05),
                    backgroundColor: const Color(0xFF604CC3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Ayo Mulai',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              // Bottom padding to prevent overflow
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
