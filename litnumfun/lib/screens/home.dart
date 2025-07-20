import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:litnumfun/screens/LeaderBoardScreenAdmin.dart';
import 'package:litnumfun/screens/LeaderboardScreen.dart';
import 'package:litnumfun/screens/ResultScreen.dart';
import 'question_screen.dart';

class Home extends StatefulWidget {
  final String name;
  final String? role; // Tambahkan parameter role

  const Home({
    super.key,
    required this.name,
    this.role,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool get isAdmin => widget.role?.toLowerCase() == 'admin';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF604CC3),
      appBar: isAdmin
          ? AppBar(
              title: const Text(
                'Admin Panel',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: const Color(0xFF604CC3),
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () => _showLogoutDialog(context),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.04),
                Text(
                  isAdmin
                      ? 'Selamat datang, ${widget.name}!'
                      : 'Halo, ${widget.name}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: screenHeight * 0.04),
                SvgPicture.asset(
                  'assets/images/litnum.svg',
                  height: screenHeight * 0.15,
                ),
                SizedBox(height: screenHeight * 0.05),

                // Tampilkan konten berdasarkan role
                if (isAdmin) ...[
                  // Konten untuk Admin
                  SizedBox(height: screenHeight * 0.06),
                  _buildAdminButton(
                    context,
                    icon: Icons.leaderboard_rounded,
                    label: 'Lihat Leaderboard',
                    color: Colors.orangeAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaderBoardScreenAdmin(),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  // Konten untuk User biasa
                  const Text(
                    "Pilih salah satu kuis:",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  _buildCategoryButton(
                      context, "Literasi", Colors.orangeAccent),
                  SizedBox(height: screenHeight * 0.03),
                  _buildCategoryButton(
                      context, "Numerasi", Colors.lightBlueAccent),
                  SizedBox(height: screenHeight * 0.06),
                  _buildSmallButton(
                    context,
                    icon: Icons.bar_chart_rounded,
                    label: 'Lihat Hasil Saya',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ResultScreen(userName: widget.name),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  _buildSmallButton(
                    context,
                    icon: Icons.leaderboard_rounded,
                    label: 'Lihat Leaderboard',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LeaderboardScreen(),
                        ),
                      );
                    },
                  ),
                ],
                SizedBox(height: screenHeight * 0.04),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, String category, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionScreen(
                category: category,
                userName: widget.name,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          shadowColor: Colors.black45,
        ),
        child: Text(
          category,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSmallButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _buildAdminButton(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 5,
          shadowColor: Colors.black45,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/', // Kembali ke halaman login
                  (route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
