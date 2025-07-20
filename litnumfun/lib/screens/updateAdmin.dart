import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:litnumfun/api_services.dart';

class UpdateAdminScreen extends StatefulWidget {
  final String adminId;
  final String currentName;
  final String currentNip;

  const UpdateAdminScreen({
    super.key,
    required this.adminId,
    required this.currentName,
    required this.currentNip,
  });

  @override
  State<UpdateAdminScreen> createState() => _UpdateAdminScreenState();
}

class _UpdateAdminScreenState extends State<UpdateAdminScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService apiService =
      ApiService(baseUrl: 'https://backup-litnumfun.vercel.app/api/v1');
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill dengan data current
    _nameController.text = widget.currentName;
    _nipController.text = widget.currentNip;
  }

  Future<void> _handleUpdate() async {
    final name = _nameController.text.trim();
    final nip = _nipController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || nip.isEmpty) {
      setState(() {
        _errorMessage = "Nama dan NIP tidak boleh kosong!";
        _successMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      Map<String, dynamic> updateData = {
        'name': name,
        'nip': nip,
      };

      // Hanya kirim password jika diisi
      if (password.isNotEmpty) {
        updateData['password'] = password;
      }

      final response = await apiService.request(
        endpoint: '/updateAdmin/${widget.adminId}',
        method: 'PUT',
        body: updateData,
      );

      setState(() {
        _isLoading = false;
      });

      if (response.containsKey('error') ||
          response.containsKey('message') &&
              response['message'].toString().toLowerCase().contains('error')) {
        setState(() {
          _errorMessage =
              response['message'] ?? response['error'] ?? "Terjadi kesalahan";
        });
      } else if (response.containsKey('message')) {
        setState(() {
          _successMessage = response['message'];
          _passwordController.clear(); // Clear password field setelah update
        });

        // Auto close setelah 2 detik
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pop(context, {
              'name': name,
              'nip': nip,
            }); // Return true untuk indicate success
          }
        });
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
      appBar: AppBar(
        title: const Text(
          'Update Admin',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4A3C9A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: screenHeight -
                AppBar().preferredSize.height -
                MediaQuery.of(context).padding.top,
          ),
          child: Column(
            children: [
              // Header dengan icon
              Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A3C9A).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.edit,
                        size: 50,
                        color: const Color(0xFF4A3C9A),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Update Data Admin',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A3C9A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Perbarui informasi admin di bawah ini',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Form section
              Padding(
                padding: const EdgeInsets.all(18),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Admin',
                    hintText: 'Masukkan nama admin',
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
                    labelText: 'NIP',
                    hintText: 'Masukkan NIP',
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
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password Baru (Opsional)',
                    hintText: 'Kosongkan jika tidak ingin mengubah password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                ),
              ),

              // Success message display
              if (_successMessage != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            color: Colors.green[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _successMessage!,
                            style: TextStyle(
                              color: Colors.green[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
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

              // Update button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleUpdate,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.9, screenHeight * 0.06),
                    backgroundColor: const Color(0xFF4A3C9A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
                          'Update Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              // Info text
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Catatan: Kosongkan field password jika tidak ingin mengubah password',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Bottom padding
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
